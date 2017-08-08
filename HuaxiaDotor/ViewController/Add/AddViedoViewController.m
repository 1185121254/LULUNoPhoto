//
//  AddViedoViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddViedoViewController.h"
#import "AddMocel.h"
#import "MJRefresh.h"
#import "AddViedoTableViewCell.h"
@interface AddViedoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddViedoViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeOrRefuse:) name:@"agreeOrRefuse" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRefuse:) name:@"refuse" object:nil];
    
    [self getDataIsRefresh:NO Parament:self.xtstr];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kWith, kHeight-159);
    _tableVIew = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableVIew.backgroundColor = [UIColor clearColor];
    _tableVIew.dataSource  =self;
    _tableVIew.delegate= self;
    _tableVIew.rowHeight = 101;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];
    
    __weak AddViedoViewController *weakSelf = self;
    _tableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataIsRefresh:YES Parament:weakSelf.xtstr];
    }];
}

-(void)getDataIsRefresh:(BOOL)isRefresh Parament:(NSString *)xtrId{
    
    __weak AddViedoViewController *weakSelf = self;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dic setObject:xtrId forKey:@"xtrId"];
    [dic setObject:@"" forKey:@"patientName"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetServiceXtrRecordList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [self setData:(NSArray *)responseObject];

        if (arry == nil || arry.count == 0) {
            weakSelf.noData.hidden = NO;
        }else
        {
            weakSelf.noData.hidden = YES;
        }
        weakSelf.arryViedo = arry;
        [weakSelf.tableVIew reloadData];
    } failure:^(NSError *error) {

    }];

    if (isRefresh == YES) {
        [_tableVIew.mj_header endRefreshing];
    }
}

-(NSMutableArray *)setData:(NSArray *)arry{
    NSMutableArray *arryData =[NSMutableArray array];
    for (NSDictionary *dicValue in arry) {
        AddMocel *add = [[AddMocel alloc]init];
        NSArray *keyarry = [dicValue allKeys];
        for (NSString *key in keyarry) {
            [add setValue:[dicValue objectForKey:key] forKey:key];
        }
        [arryData addObject:add];
    }
    return  arryData;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arryViedo.count;
}

-(AddViedoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse= @"patient";
    AddViedoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[AddViedoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    AddMocel *patient = _arryViedo[indexPath.row];
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,patient.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    cell.lblName.text = [NSString stringWithFormat:@"%@    %@  %@岁",patient.patientName,[self setSec:patient.sex],patient.age];
    cell.lblTime.text = patient.createDate;
    if ([patient.state integerValue] == 0) {
        cell.lblState.hidden = YES;
        cell.btnAgree.hidden = NO;
        cell.btnRefuse.hidden = NO;
        
    }else if ([patient.state integerValue] == 1){
        cell.lblState.hidden = NO;
        cell.btnAgree.hidden = YES;
        cell.btnRefuse.hidden = YES;
        cell.lblState.text = @"已同意";
    }else if ([patient.state integerValue] == 2){
        cell.lblState.hidden = NO;
        cell.btnAgree.hidden = YES;
        cell.btnRefuse.hidden = YES;
        cell.lblState.text = @"已拒绝";
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark ---------通知
-(void)agreeOrRefuse:(NSNotification *)notify{
    NSDictionary *dicCell = notify.userInfo;
    AddViedoTableViewCell *cell = [dicCell objectForKey:@"cell"];
    NSIndexPath *index = [_tableVIew indexPathForCell:cell];
    AddMocel *patient = _arryViedo[index.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:patient.Id forKey:@"id"];
    if ([[dicCell objectForKey:@"tag"] integerValue]==101) {
        [dic setObject:@"1" forKey:@"state"];
    }else
    {
        [dic setObject:@"2" forKey:@"state"];
    }

    __weak AddViedoViewController *weakSelf = self;
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceXtrRecordModify",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        [weakSelf getDataIsRefresh:NO Parament:patient.xtrId];

    } failure:^(NSError *error) {

    }];
}

#pragma mark ---------辅助方法
-(NSString *)setSec:(NSString *)mess{
    
    NSString *sex;
    if ([mess isEqualToString:@"1"]) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    return sex;
}

-(BOOL)setTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    long long AppointUnit = [date timeIntervalSince1970];
    long long nowUnit = [[NSDate date] timeIntervalSince1970];
    
    if (AppointUnit < nowUnit) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
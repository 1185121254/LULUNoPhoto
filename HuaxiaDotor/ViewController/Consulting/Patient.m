
//
//  Patient.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "Patient.h"
#import "PatientModel.h"
#import "PatentTableViewCell.h"
#import "ChartViewController.h"
#import "MJRefresh.h"

@interface Patient ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_viewB;
}
@end

@implementation Patient

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *doctorID                = [userDefaults objectForKey:@"id"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:doctorID forKey:@"doctorId"];
    [parameters setValue:@"1"      forKey:@"orderType"];
    [parameters setObject:@""      forKey:@"patientName"];


    
    

    [parameters setObject:self.state forKey:@"state"];
    [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters  viewConroller:self  Complation:^(NSMutableArray *arry) {

        if (arry == nil || arry.count == 0) {
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
            self.arryPatient   = [NSString shengXuPatientConC:arry];
        [self.tableVIew reloadData];
    } Fail:^(NSError *error) {

        kReuestFaile;
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame                   = CGRectMake(0, 0, kWith, kHeight-159);
    
    _tableVIew                        = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableVIew.backgroundColor        = [UIColor clearColor];
    _tableVIew.dataSource             = self;
    _tableVIew.delegate               = self;
    _tableVIew.separatorStyle         = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];

    MJRefreshNormalHeader *header     = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    [header setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    _tableVIew.mj_header              = header;
}

-(void)dealloc{

}

-(void)pullDown{

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *doctorID                = [userDefaults objectForKey:@"id"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:doctorID forKey:@"doctorId"];
    [parameters setValue:@"1" forKey:@"orderType"];
    [parameters setObject:self.state forKey:@"state"];
    [parameters setObject:@"" forKey:@"patientName"];

    [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters   viewConroller:self Complation:^(NSMutableArray *arry) {
        if (arry == nil || arry.count == 0) {
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        self.arryPatient   = [NSString shengXuPatientConC:arry];
        [self.tableVIew reloadData];
    }Fail:^(NSError *error) {
        kReuestFaile;
    }];
    [_tableVIew.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arryPatient.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

-(PatentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse      = @"patient";
    PatentTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
    cell                        = [[PatentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    if ([self.state isEqualToString:@"4"]) {
    cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    cell.lblNewMeg.hidden       = YES;
    }else
    {
    cell.accessoryType          = UITableViewCellAccessoryNone;
    cell.lblNewMeg.hidden       = NO;
    }
    PatientModel *model         = self.arryPatient[indexPath.row];
    NSString *Sex;
    if ([model.sex isEqualToString:@"1"]) {
    Sex                         = @"男";
    }else{
    Sex                         = @"女";
    }
    cell.lblName.attributedText = [self setText:[NSString stringWithFormat:@"%@  %@ %@岁",model.patientName,Sex,model.age]];
    cell.lblText.text           = [NSString stringWithFormat:@"症状描述:%@",model.Description];
    if (model.newMessage == 0) {
    cell.lblNewMeg.hidden       = YES;
    }else
    {
    cell.lblNewMeg.text         = [NSString stringWithFormat:@"%ld",model.newMessage];
    }

    cell.lblTime.text                 = model.latestDate;

    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,model.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ChartViewController *chat = [[ChartViewController alloc]init];
    chat.patient              = self.arryPatient[indexPath.row];
    chat.state                = self.state;

    [self.navigationController pushViewController:chat animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{

    NSArray *arry                     = [text componentsSeparatedByString:@"  "];
    NSString *strUnit                 = arry[1];

    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[text rangeOfString:strUnit]];
    return medStr;
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

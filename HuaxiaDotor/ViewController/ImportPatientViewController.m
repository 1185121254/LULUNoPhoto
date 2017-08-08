//
//  ImportPatientViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ImportPatientViewController.h"
#import "GroupModel.h"
#import "GroupDetailModel.h"
#import "GruopDetailTableViewCell.h"
#import "PersonCenterClipViewController.h"
#import "SearchGroupViewController.h"

@interface ImportPatientViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableImport;
    NSMutableArray *_arryGroup;
    NSMutableArray *_arryState;
    
}
@end

@implementation ImportPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title  =@"病历夹";
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 64+10, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchCAseIMport) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    _tableImport = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWith, kHeight - 110) style:UITableViewStyleGrouped];
    _tableImport.dataSource = self;
    _tableImport.delegate = self;
    _tableImport.rowHeight = 60;
    [self.view addSubview:_tableImport];
    
    [_tableImport registerClass:[UITableViewCell class] forCellReuseIdentifier:@"patientImport"];

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetGroupByDoc",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        NSMutableArray *arryData = [NSMutableArray array];
        for (NSDictionary *dicValue in (NSArray *)responseObject) {
            GroupModel *group = [[GroupModel alloc]init];
            for (NSString *key in [dicValue allKeys]) {
                [group setValue:[dicValue objectForKey:key] forKey:key];
            }
            [arryData addObject:group];
        }
        _arryGroup = arryData;
        _arryState  = [NSMutableArray array];
        for (NSInteger i = 0; i<_arryGroup.count; i++) {
            [_arryState addObject:@"hidden"];
        }
        [_tableImport reloadData];

    } failure:^(NSError *error) {

    }];
}

#pragma mark--------------设置列表
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryGroup.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *state = _arryState[section];
    GroupModel *model = _arryGroup[section];
    if ([state isEqualToString:@"hidden"]) {
        return 0;
    }else{
        return model.groupDetail.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *str = _arryState[section];
    UIView *viewHeader =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    viewHeader.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 10)];
    if ([str isEqualToString:@"hidden"]) {
        image.image = [UIImage imageNamed:@"arrow_up_gray"];
    }else
    {
        image.image = [UIImage imageNamed:@"arrow_down_gray"];
    }
    [viewHeader addSubview:image];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, kWith - 50, 30)];
    GroupModel *model = _arryGroup[section];
    lbl.text = model.groupName;
    lbl.font = [UIFont systemFontOfSize:14];
    [viewHeader addSubview:lbl];
    
    UIControl *colon = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    colon.tag = 1300+section;
    [colon addTarget:self action:@selector(onStateTableGropImport:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:colon];
    
    return viewHeader;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *user = @"ClipGroupDetail";
    GruopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:user];
    if (cell == nil) {
        cell = [[GruopDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:user];
    }
    GroupModel *model = _arryGroup[indexPath.section];
    GroupDetailModel *detailModel = model.groupDetail[indexPath.row];
    cell.lblName.text = detailModel.name;
    [cell.imageAvater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",NET_URLSTRING]] placeholderImage:[UIImage imageNamed:@"人物"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupModel *model = _arryGroup[indexPath.section];
    GroupDetailModel *detailModel = model.groupDetail[indexPath.row];
    PersonCenterClipViewController *per = [[PersonCenterClipViewController alloc]init];
    per.group = detailModel;
    if ([self.from isEqualToString:@"webImport"]) {
        per.from = @"webImport";
    }else
    {
        per.from = @"importPatient";
    }
    [self.navigationController pushViewController:per animated:YES];
}

#pragma mark--------------折合表
-(void)onStateTableGropImport:(UIControl *)colo{
    
    NSString *str = _arryState[colo.tag - 1300];
    if ([str isEqualToString:@"hidden"]) {
        [_arryState replaceObjectAtIndex:colo.tag - 1300 withObject:@"show"];
        GroupModel *model = _arryGroup[colo.tag - 1300];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.Id forKey:@"groupId"];

        
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetPatientByGroup",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            
            NSMutableArray *arryData = [NSMutableArray array];
            for (NSDictionary *dicValue in (NSArray *)responseObject) {
                GroupDetailModel *groupD = [[GroupDetailModel alloc]init];
                for (NSString *key in [dicValue allKeys]) {
                    [groupD setValue:[dicValue objectForKey:key] forKey:key];
                }
                [arryData addObject:groupD];
            }
            model.groupDetail = arryData;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:colo.tag - 1300];
            [_tableImport reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

        } failure:^(NSError *error) {

        }];

    }else
    {
        [_arryState replaceObjectAtIndex:colo.tag - 1300 withObject:@"hidden"];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:colo.tag - 1300];
        [_tableImport reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)onSearchCAseIMport{
    SearchGroupViewController *search = [[SearchGroupViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

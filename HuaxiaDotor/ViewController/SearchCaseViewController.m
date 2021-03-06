//
//  SearchCaseViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchCaseViewController.h"
#import "CaseModel.h"
#import "CaseDiscussTableViewCell.h"
#import "CaseCommentViewController.h"
@interface SearchCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryData;
    
    UITableView *_tableViewSear;
    PublishNav *_publish;

}

@end

@implementation SearchCaseViewController

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.navigationController.navigationBar.hidden = YES;

    _publish= [[PublishNav alloc]init];
    [_publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    _publish.title.text = @"讨论中的病历";
    [self.view addSubview:_publish];
    
    _text= [[UITextField alloc]initWithFrame:CGRectMake(10, 64+10, kWith-20-70, 30)];
    _text.placeholder = @"请根据患者姓名进行搜索";
    _text.borderStyle = UITextBorderStyleRoundedRect;
    _text.textAlignment = 1;
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_text];

    UIButton  *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(kWith - 70, 64+10, 60, 30);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.backgroundColor = BLUECOLOR_STYLE;
    btnSearch.layer.cornerRadius = 3;
    [btnSearch addTarget:self action:@selector(onBtnSearchCase) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114)];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerClass:[CaseDiscussTableViewCell class] forCellReuseIdentifier:@"CaseSearch"];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 71;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CaseDiscussTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"CaseSearch" forIndexPath:indexPath];
    CaseModel *model = _arryData[indexPath.row];
    NSString *Sex;
    if ([model.sex isEqualToString:@"1"]) {
        Sex = @"男";
    }else{
        Sex = @"女";
    }
    cell.lblName.attributedText = [self setText:[NSString stringWithFormat:@"%@    %@  %@岁",model.patientName,Sex,model.age]];
    cell.lblTime.text =  model.createDate;
    cell.lblDesp.text = [NSString stringWithFormat:@"症状描述:%@",model.illness];
    if ([model.NewMessage integerValue] == 0) {
        cell.lblNewMeg.hidden = YES;
    }else
    {
        cell.lblNewMeg.hidden = NO;
        cell.lblNewMeg.text = model.NewMessage;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CaseModel *model = _arryData[indexPath.row];
    CaseCommentViewController *casep = [[CaseCommentViewController alloc]init];
    casep.model = model;
    [self.navigationController pushViewController:casep animated:YES];
    
}

#pragma mark--------搜索
-(void)onBtnSearchCase{
    [_text resignFirstResponder];
    [_arryData removeAllObjects];
    [_tableViewSear reloadData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"rows"];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dic setObject:_text.text forKey:@"patientName"];

    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/DiscussionListFind",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        NSArray *array = [self detailWithData:(NSArray *)responseObject];
        if (array.count == 0) {
            kAlter(@"无结果");
        }else
        {
            _arryData = [self shengXuPatientConCSear:array];
            [self getUnReadMsg];
            [_tableViewSear reloadData];
        }
    } failure:^(NSError *error) {

    }];
}

-(NSMutableArray *)detailWithData:(NSArray *)arry{
    NSMutableArray *arryData = [NSMutableArray array];
    
    for (NSDictionary *dicValue in arry) {
        CaseModel *model = [[CaseModel alloc]init];
        for (NSString *key in [dicValue allKeys]) {
            [model setValue:[dicValue objectForKey:key] forKey:key];
        }
        [arryData addObject:model];
    }
    return arryData;
}

-(void)onLeftBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[text rangeOfString:strUnit]];
    return medStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------升序
-(NSMutableArray *)shengXuPatientConCSear:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {
        
        NSDate *date1 = [dateFormatter dateFromString:modelM1.latestDate];
        NSDate *date2 = [dateFormatter dateFromString:modelM2.latestDate];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }]];
    return array;
}

#pragma mark-------未读消息变已读

-(void)getUnReadMsg{
    
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    
    for (CaseModel *model in _arryData) {
        
        for (NIMRecentSession *recentSession in _recentSessions) {
            
            if ([recentSession.session.sessionId isEqualToString:model.teamId]) {
                
                model.NewMessage = [NSString stringWithFormat:@"%ld",(long)recentSession.unreadCount];
                //                NSDate *date = [NSDate dateWithTimeIntervalSince1970:recentSession.lastMessage.timestamp];
                //                model.latestDate = [_dateformatte stringFromDate:date];
            }
        }
        
    }
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

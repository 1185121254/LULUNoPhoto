//
//  SearcReportViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearcReportViewController.h"
#import "ReportTableTableViewCell.h"
#import "PatientListrepotViewController.h"
#import "PatientReportChatViewController.h"

@interface SearcReportViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryApplica;
    NSMutableArray *_arryAlreadyApplica;

    UITableView *_tableViewSear;

}

@end

@implementation SearcReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"患者报到";
    self.view.backgroundColor = kBackgroundColor;
    
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
    [btnSearch addTarget:self action:@selector(onBtnSearchReport) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114) style:UITableViewStyleGrouped];
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.rowHeight = 71;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerClass:[ReportTableTableViewCell class] forCellReuseIdentifier:@"reportSearch"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyReportPatientSearch:) name:@"reportPatient" object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _arryApplica.count;
    }else
    {
        return _arryAlreadyApplica.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReportTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportSearch" forIndexPath:indexPath];
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = _arryApplica[indexPath.row];
    }else
    {
        dic = _arryAlreadyApplica[indexPath.row];
    }

    [cell setPatientData:dic state:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        NSDictionary *dic = _arryApplica[indexPath.row];
        PatientListrepotViewController *list = [[PatientListrepotViewController alloc]init];
        list.patientID = [dic objectForKey:@"patientId"];
        [self.navigationController pushViewController:list animated:YES];
    }else
    {
        NSDictionary *dic = _arryAlreadyApplica[indexPath.row];
        PatientReportChatViewController *chat = [[PatientReportChatViewController alloc]init];
        chat.patientDoc = dic;
        chat.from = @"report";
        [self.navigationController pushViewController:chat animated:YES];
    }
}

-(void)onBtnSearchReport{
    [self.view endEditing:YES];

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",@"0",@"visState",_text.text,@"patientName", nil];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDValidateList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

        _arryApplica = arry;
        [_tableViewSear reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    } failure:^(NSError *error) {

    }];

    
    NSDictionary *dicAlready = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",_text.text,@"patientName", nil];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDFriendList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicAlready viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

        _arryAlreadyApplica = arry;
        [_tableViewSear reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];

    } failure:^(NSError *error) {

    }];

}

-(void)onNotifyReportPatientSearch:(NSNotification *)notify{
    ReportTableTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];

    NSDictionary *dicData = _arryApplica[index.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",[dicData objectForKey:@"patientId"],@"patientId",[dicData objectForKey:@"validateId"],@"validateId", nil];

    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/PDFriendUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",@"0",@"visState",_text.text,@"patientName", nil];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDValidateList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];
            

            _arryApplica = arry;
            [_tableViewSear reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {

        }];

    } failure:^(NSError *error) {

    }];
}

//富文本
-(NSMutableAttributedString *)setNameText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
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

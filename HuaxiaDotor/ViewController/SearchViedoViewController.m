//
//  SearchViedoViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchViedoViewController.h"
#import "AddViedoTableViewCell.h"
#import "ChatViedoTableViewCell.h"
#import "AddMocel.h"
#import "NetCallChatInfo.h"
#import "NTESVideoChatViewController.h"
//#import "DiagnosticAdviceViewController.h"
#import "ScrollAdviceViewController.h"

#import "ConsultationDetailViewController.h"

@interface SearchViedoViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryAdd;
    NSMutableArray *_arryChat;
    
    UITableView *_tableViewSear;
    

}

@end

@implementation SearchViedoViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_text.text == nil || [_text.text isEqualToString:@""]) {
        NSLog(@"------");
    }else
    {
        //BODY
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
        [parameters setValue:@"3" forKey:@"orderType"];
        [parameters setObject:@"" forKey:@"state"];
        [parameters setObject:_text.text forKey:@"patientName"];
        NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:[kUserDefatuel objectForKey:@"verifyCode"]};

        
        [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters   viewConroller:self Complation:^(NSMutableArray *arry) {

            _arryChat = arry;
            [_tableViewSear reloadData];
        }Fail:^(NSError *error) {

            kReuestFaile;
        }];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyChat:) name:@"viedo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onAgreeAdd:) name:@"agree" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRefuseAdd:) name:@"refuse" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"视频咨询";
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
    [btnSearch addTarget:self action:@selector(onBtnSearchViedo) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114) style:UITableViewStyleGrouped];
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerClass:[AddViedoTableViewCell class] forCellReuseIdentifier:@"SearchAddViedo"];
    [_tableViewSear registerClass:[ChatViedoTableViewCell class] forCellReuseIdentifier:@"SearchChatViedo"];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _arryAdd.count;
    }else
    {
        return _arryChat.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 101;
    }else
    {
        return 81;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        AddViedoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchAddViedo" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AddMocel *patient = _arryAdd[indexPath.row];
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
    else
    {
        ChatViedoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchChatViedo" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PatientModel *patient = _arryChat[indexPath.row];
        [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,patient.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
        cell.lblName.text = [NSString stringWithFormat:@"%@  %@  %@岁",patient.patientName,[self setSec:patient.sex],patient.age];
        cell.btnCallNow.tag = [patient.state integerValue] + 720;
        
        if ([patient.state integerValue] == 6) {
            [cell.btnCallNow setTitle:@"未接通" forState:UIControlStateNormal];
            cell.btnCallNow.backgroundColor = [UIColor clearColor];
            [cell.btnCallNow setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.btnCallNow.userInteractionEnabled  =  NO;
            cell.lblState.text = @"完成时间:";
            cell.lblTime.text = patient.modifyDate;
            
        }else if ([patient.state integerValue]==4) {
            cell.lblState.text = @"完成时间:";
            cell.lblTime.text = patient.modifyDate;
            
            [cell.btnCallNow setTitle:@"诊断建议" forState:UIControlStateNormal];
            [cell.btnCallNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if ([patient.writeState isEqualToString:@"0"]) {
                    
                cell.btnCallNow.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
                cell.btnCallNow.userInteractionEnabled = YES;
            }else
               {
                cell.btnCallNow.backgroundColor = [UIColor colorWithRed:157/255.0 green:213/255.0 blue:106/255.0 alpha:1];
                cell.btnCallNow.userInteractionEnabled = YES;
            }
        }
        else
        {
            cell.btnCallNow.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [cell.btnCallNow setTitle:@"发起视频" forState:UIControlStateNormal];
            [cell.btnCallNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            cell.lblTime.text = patient.createDate;
            cell.lblState.text = @"下单时间:";
            cell.btnCallNow.hidden = NO;
        }
        return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        PatientModel *patient = _arryChat[indexPath.row];
        ConsultationDetailViewController *con = [[ConsultationDetailViewController alloc]init];
        con.patient = patient;
        con.from = @"phone";
        [self.navigationController pushViewController:con animated:YES];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onBtnSearchViedo{
    [_text resignFirstResponder];


    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setValue:@"3" forKey:@"orderType"];
    [parameters setObject:@"" forKey:@"state"];
    [parameters setObject:_text.text forKey:@"patientName"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parameters viewConroller:self success:^(id responseObject) {

        _arryChat = [PublicTools setData:(NSArray *)responseObject];
        [_tableViewSear reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError *error) {

    }];


    NSMutableDictionary *dicP = [NSMutableDictionary dictionary];
    [dicP setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [RequestManager startViedoChat:[NSString stringWithFormat:@"%@/api/Share/GetServiceRecord",NET_URLSTRING] Parameters:dicP viewConroller:self Complation:^(NSString *xtrId, NSNumber *serviceAmount, NSNumber *isFree, NSNumber *code) {

        if (code == nil) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
            [dic setObject:xtrId forKey:@"xtrId"];
            [dic setObject:@"" forKey:@"patientName"];
            [dic setObject:_text.text forKey:@"patientName"];
            [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetServiceXtrRecordList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
                _arryAdd = [self setData:(NSArray *)responseObject];
                [_tableViewSear reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                
            }];

        }

    } Fail:^(NSError *error) {

        kAlter(kFail);
    }];
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

#pragma mark ---------拨通视频
-(void)onNotifyChat:(NSNotification *)notify{
    ChatViedoTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];
    PatientModel *patient = _arryChat[index.row];

    if (cell.btnCallNow.tag == 721) {
        if ([patient.state integerValue]==1) {
            if (_arryChat.count > 0) {
                NetCallChatInfo *of = [[NetCallChatInfo alloc]init];
                of.callee = patient.patientIM;
                of.orderID = patient.Id;
                of.callType = NIMNetCallTypeVideo;
                NTESVideoChatViewController *set = [[NTESVideoChatViewController alloc] initWithCallInfo:of];
                [self presentViewController:set animated:YES completion:nil];
            }
        }
    }
    else
    {
        if ([patient.state integerValue]==4) {
            if (_arryChat.count > 0) {
                PatientModel *patient = _arryChat[index.row];
                if ([patient.writeState isEqualToString:@"0"]) {
                    ScrollAdviceViewController *dia = [[ScrollAdviceViewController alloc]init];
                    dia.patient = patient;
                    dia.from = @"BeenAA";
                    [self.navigationController pushViewController:dia animated:YES];
                }else
                {
                    ScrollAdviceViewController *dia = [[ScrollAdviceViewController alloc]init];
                    dia.patient = patient;
                    dia.from = @"BeenDia";
                    [self.navigationController pushViewController:dia animated:YES];
                }
                
            }
        }
        
    }

}

#pragma mark ---------同意
-(void)onAgreeAdd:(NSNotification *)notify{
    AddViedoTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];
    AddMocel *patient = _arryAdd[index.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:patient.Id forKey:@"id"];
    [dic setObject:@"1" forKey:@"state"];


    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceXtrRecordModify",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
        [dic setObject:patient.xtrId forKey:@"xtrId"];
        [dic setObject:_text.text forKey:@"patientName"];
        [self onBtnALl:dic URL:[NSString stringWithFormat:@"%@/api/Share/GetServiceXtrRecordList",NET_URLSTRING]];


    } failure:^(NSError *error) {

    }];
}

-(void)onBtnALl:(NSDictionary *)dic URL:(NSString *)url{

    [RequestManager getWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        _arryAdd = [self setData:(NSArray *)responseObject];
        [_tableViewSear reloadData];

    } failure:^(NSError *error) {

    }];
}

#pragma mark ---------拒绝
-(void)onRefuseAdd:(NSNotification *)notify{
    
    AddViedoTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];
    AddMocel *patient = _arryAdd[index.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:patient.Id forKey:@"id"];
    [dic setObject:@"2" forKey:@"state"];


    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceXtrRecordModify",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
        [dic setObject:patient.xtrId forKey:@"xtrId"];
        [dic setObject:_text.text forKey:@"patientName"];
        [self onBtnALl:dic URL:[NSString stringWithFormat:@"%@/api/Share/GetServiceXtrRecordList",NET_URLSTRING]];


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
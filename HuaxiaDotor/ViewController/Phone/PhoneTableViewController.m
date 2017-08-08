//
//  PhoneTableViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PhoneTableViewController.h"
#import "MJRefresh.h"
#import "PatientModel.h"
#import "PhoneTableViewCell.h"
//#import "DiagnosticAdviceViewController.h"
#import "ConsultationDetailViewController.h"
#import "ScrollAdviceViewController.h"

@interface PhoneTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isCanCall;
    NSDateFormatter *_formatter;

}
@end

@implementation PhoneTableViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCallNow:) name:@"callNow" object:nil];

    //BODY
    [self setData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCanCall = YES;
    self.view.frame = CGRectMake(0, 0, kWith, kHeight-159);
    _tableVIew = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableVIew.backgroundColor = [UIColor clearColor];
    _tableVIew.dataSource  =self;
    _tableVIew.delegate= self;
    _tableVIew.rowHeight = 81;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];
    
     _formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    [header setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    _tableVIew.mj_header = header;
    
}

-(void)dealloc{

}

-(void)setData{

    
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setObject:@"" forKey:@"patientName"];
    [parameters setValue:@"2" forKey:@"orderType"];
    [parameters setObject:self.state forKey:@"state"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parameters viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [PublicTools setData:(NSArray *)responseObject];

        if (arry == nil || arry.count == 0) {
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        self.arryPatient = [self shengXuPatientConPhone:arry];
        [self.tableVIew reloadData];
        
    } failure:^(NSError *error) {

    }];
}

-(void)pullDown{

    [self setData];
    [_tableVIew.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arryPatient.count;
}

-(PhoneTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse= @"patient";
    PhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[PhoneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    PatientModel *patient = _arryPatient[indexPath.row];
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,patient.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    cell.lblName.attributedText = [self setText:[NSString stringWithFormat:@"%@  %@ %@岁",patient.patientName,[self setSec:patient.sex],patient.age]];
    cell.btnCallNow.tag = [self.state integerValue] + 700;
    
    if (_isCanCall == YES) {
        cell.btnCallNow.userInteractionEnabled = YES;
    }else
    {
        cell.btnCallNow.userInteractionEnabled = NO;
    }
    
    if ([self.state isEqualToString:@"4"]) {
        cell.btnOutTime.hidden = YES;
        cell.lblState.text = @"完成时间:";

        if ([patient.state integerValue] == 6) {
            
            cell.lblTime.text = [self setAddTwoHour:patient.dealTime];
            [cell.btnCallNow setTitle:@"未拨通" forState:UIControlStateNormal];
            cell.btnCallNow.backgroundColor = [UIColor clearColor];
            [cell.btnCallNow setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.btnCallNow.userInteractionEnabled  =  NO;
        }
        else
        {
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
    }
    else
    {
        cell.lblState.text = @"预约时间:";
        cell.lblTime.text = patient.dealTime;
        cell.btnCallNow.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
        [cell.btnCallNow setTitle:@"现在拨通" forState:UIControlStateNormal];
        [cell.btnCallNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.btnOutTime.hidden = [self setTime:patient.dealTime];
        cell.btnCallNow.hidden = NO;

    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientModel *patient = _arryPatient[indexPath.row];
    ConsultationDetailViewController *con = [[ConsultationDetailViewController alloc]init];
    con.patient = patient;
    con.from = @"phone";
    [self.navigationController pushViewController:con animated:YES];
}


#pragma mark ---------通知

-(void)onCallNow:(NSNotification *)notify{
    PhoneTableViewCell *cell = notify.object;
    
    if (cell.btnCallNow.tag == 701) {
        if ([self.state isEqualToString:@"1"]) {
            if (self.arryPatient.count > 0) {
                NSIndexPath *index = [_tableVIew indexPathForCell:cell];
                PatientModel *patient = self.arryPatient[index.row];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:patient.Id forKey:@"orderId"];
                [dic setObject:patient.doctorIM forKey:@"accId"];
                if (patient.doctorTel == nil || [patient.doctorTel isEqualToString:@""]) {
                    kAlter(@"医生号码为空");
                    return;
                }
                if (patient.patientTel == nil || [patient.patientTel isEqualToString:@""]) {
                    kAlter(@"患者号码为空");
                    return;
                }
                [dic setObject:patient.doctorTel forKey:@"caller"];
                [dic setObject:patient.patientTel forKey:@"callee"];
                

                [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/ExtendApi/CallPhone",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

                    [self Countdown:cell.contentView];

                } failure:^(NSError *error) {

                }];
            }
        }
    }
    else{
        if ([self.state isEqualToString:@"4"]) {
            if (self.arryPatient.count >0) {
                
                NSIndexPath *index = [_tableVIew indexPathForCell:cell];
                PatientModel *patient = _arryPatient[index.row];
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

    NSDate *date = [_formatter dateFromString:time];
    long long AppointUnit = [date timeIntervalSince1970];
    long long nowUnit = [[NSDate date] timeIntervalSince1970];
    
    if (AppointUnit < nowUnit) {
        return NO;
    }
    
    {
        return YES;
    }
}

#pragma mark--------升序
-(NSArray *)shengXuPatientConPhone:(NSArray *)arry{
    
    NSArray * array = [arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {
        
        NSDate *date1 = [_formatter dateFromString:modelM1.createDate];
        NSDate *date2 = [_formatter dateFromString:modelM2.createDate];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    return array;
}

//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[text rangeOfString:strUnit]];
    return medStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Countdown:(UIView *)view{

    //现在拨通的位置
    UILabel *aUILabel = [[UILabel alloc]initWithFrame:CGRectMake(kWith-10-70, 10, 70, 30)];
    aUILabel.backgroundColor = kBoradColor;
    aUILabel.textColor = [UIColor whiteColor];
    aUILabel.font = [UIFont systemFontOfSize:13];
    aUILabel.layer.cornerRadius = 5;
    aUILabel.layer.masksToBounds = YES;
    [view addSubview:aUILabel];
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:aUILabel andTimerType:MZTimerLabelTypeTimer];
    timer.timeFormat = @"ss秒后重播";
    timer.textAlignment = 1;
    [timer setCountDownTime:60];
    
    _isCanCall = NO;
    [_tableVIew reloadData];
    
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        
        [aUILabel removeFromSuperview];
        _isCanCall = YES;
        [_tableVIew reloadData];
        
    }];
}


#pragma mark--------加两个小时

-(NSString *)setAddTwoHour:(NSString *)date{

    NSDate *dateOld = [_formatter dateFromString:date];
    long long unit = [dateOld timeIntervalSince1970] + 60*60*2;
    NSDate *dateNew = [NSDate dateWithTimeIntervalSince1970:unit];
    return [_formatter stringFromDate:dateNew];
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

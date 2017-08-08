//
//  ChatViedoViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ChatViedoViewController.h"
#import "MJRefresh.h"
#import "PatientModel.h"
#import "ChatViedoTableViewCell.h"
#import "ConsultationDetailViewController.h"
#import "NetCallChatInfo.h"
#import "NTESVideoChatViewController.h"
//#import "DiagnosticAdviceViewController.h"
#import "NTESNetChatViewController.h"

#import "ScrollAdviceViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatViedoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChatViedoViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotify:) name:@"viedo" object:nil];
    
    if ([self.from isEqualToString:@"presenting"]) {
        kAlter(@"时间到了，视频资讯结束！");
    }

    [self setData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kWith, kHeight-159);
    _tableVIew = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableVIew.backgroundColor = [UIColor clearColor];
    _tableVIew.dataSource  =self;
    _tableVIew.delegate= self;
    _tableVIew.rowHeight = 81;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    [header setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    _tableVIew.mj_header = header;

}

-(void)dealloc{

}

-(void)setData{
    

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dic setObject:self.state forKey:@"state"];
    [dic setObject:@"3" forKey:@"orderType"];
    [dic setObject:@"" forKey:@"patientName"];
    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        NSMutableArray *arry = [PublicTools setData:(NSArray *)responseObject];
        if (arry == nil || arry.count == 0) {
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        self.arryViedo = [self shengXuPatientViedo:arry];
        [self.tableVIew reloadData];
    } failure:^(NSError *error) {

    }];
}

-(void)pullDown{

    [self setData];
    [_tableVIew.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arryViedo.count;
}

-(ChatViedoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse= @"patient";
    ChatViedoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[ChatViedoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    PatientModel *patient = _arryViedo[indexPath.row];
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,patient.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    cell.lblName.attributedText = [self setText:[NSString stringWithFormat:@"%@  %@ %@岁",patient.patientName,[self setSec:patient.sex],patient.age]];
    cell.btnCallNow.tag = [self.state integerValue] + 720;
    
    if ([self.state isEqualToString:@"4"]) {
        cell.lblState.text = @"完成时间:";
        cell.lblTime.text = patient.modifyDate;
        if ([patient.state integerValue] == 6) {
            [cell.btnCallNow setTitle:@"未接通" forState:UIControlStateNormal];
            cell.btnCallNow.backgroundColor = [UIColor clearColor];
            [cell.btnCallNow setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.btnCallNow.userInteractionEnabled  =  NO;
        }
        else
        {
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
        cell.btnCallNow.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
        [cell.btnCallNow setTitle:@"发起视频" forState:UIControlStateNormal];
        [cell.btnCallNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.lblTime.text = patient.createDate;
        cell.lblState.text = @"下单时间:";
        cell.btnCallNow.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PatientModel *patient = _arryViedo[indexPath.row];
    ConsultationDetailViewController *con = [[ConsultationDetailViewController alloc]init];
    con.patient = patient;
    con.from = @"phone";
    [self.navigationController pushViewController:con animated:YES];
    
}

#pragma mark ---------通知
-(void)onNotify:(NSNotification *)notify{

    ChatViedoTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableVIew indexPathForCell:cell];
    if (cell.btnCallNow.tag == 721) {
        if ([self.state isEqualToString:@"1"]) {
            if (self.arryViedo.count > 0) {
                if ([self initCamera]) {
                    PatientModel *patient = _arryViedo[index.row];
                    NetCallChatInfo *of = [[NetCallChatInfo alloc]init];
                    of.callee = patient.patientIM;
                    of.caller = kDoctorIM;
                    of.orderID = patient.Id;
                    of.from = @"viedo";
                    NTESVideoChatViewController *set = [[NTESVideoChatViewController alloc] initWithCallInfo:of];
                    [self presentViewController:set animated:YES completion:nil];
                }
            }
        }
    }
    else
    {
        if ([self.state isEqualToString:@"4"]) {
            if (self.arryViedo.count > 0) {
                PatientModel *patient = _arryViedo[index.row];
                if ([patient.writeState isEqualToString:@"0"]) {
                    ScrollAdviceViewController *dia = [[ScrollAdviceViewController alloc]init];
                    dia.patient = patient;
                    dia.from = @"BeenAA";
                    [self.navigationController pushViewController:dia animated:YES];
                }else if([patient.writeState isEqualToString:@"1"]){
                    ScrollAdviceViewController *dia = [[ScrollAdviceViewController alloc]init];
                    dia.patient = patient;
                    dia.from = @"BeenDia";
                    [self.navigationController pushViewController:dia animated:YES];
                }else
                {
                    return;
                }
            }
        }
    
    }
}

//判断是否有相机
- (BOOL)initCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"检测不到相机设备"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"相机权限受限"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
        
    }
    return YES;
}

#pragma mark ---------辅助方法
//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[text rangeOfString:strUnit]];
    return medStr;
}

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

#pragma mark--------升序
-(NSMutableArray *)shengXuPatientViedo:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {
        NSDate *date1 = [dateFormatter dateFromString:modelM1.createDate];
        NSDate *date2 = [dateFormatter dateFromString:modelM2.createDate];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }]];
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    NSLog(@"--------------------");
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
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

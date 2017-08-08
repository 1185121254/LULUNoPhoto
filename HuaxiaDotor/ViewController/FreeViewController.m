//
//  FreeViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FreeViewController.h"
#import "PatentTableViewCell.h"
#import "PatientModel.h"
#import "FreeCahtViewController.h"

@interface FreeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDateFormatter *_dateFormatter;
}
@end

@implementation FreeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *dic = @{@"doctorId":[kUserDefatuel objectForKey:@"id"],@"state":self.state,@"doctorIM":kDoctorIM};
    NSDictionary *dicHeader = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};

    [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetQuestionList",NET_URLSTRING] heads:dicHeader parameters:dic   viewConroller:self Complation:^(NSMutableArray *arry) {
        if (arry == nil || arry.count == 0) {
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        _arryData = [self shengXuPatientConFree:arry];
        [_freeTable reloadData];
    }Fail:^(NSError *error) {

        kReuestFaile;
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    self.view.frame = CGRectMake(0, 0, kWith, kHeight-60-50-2-50);
    _freeTable =[[UITableView alloc]initWithFrame:self.view.frame];
    _freeTable.backgroundColor = [UIColor clearColor];
    _freeTable.dataSource = self;
    _freeTable.delegate = self;
    _freeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _freeTable.rowHeight = 81;
    [self.view addSubview:_freeTable];

    [_freeTable registerClass:[PatentTableViewCell class] forCellReuseIdentifier:@"FeeeConsult"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(PatentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeeeConsult" forIndexPath:indexPath];
    PatientModel *model = _arryData[indexPath.row];
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,model.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    NSString *Sex;
    if ([model.sex isEqualToString:@"1"] ||[model.sex isEqualToString:@"男"]) {
        Sex = @"男";
    }else{
        Sex = @"女";
    }
    cell.lblName.attributedText = [self setTextFree:[NSString stringWithFormat:@"%@  %@ %@岁",model.name,Sex,model.age]];
    cell.lblText.text = model.questionDetail;
    cell.lblTime.text = model.modifyDate;

    if ([self.state integerValue]==3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lblNewMeg.hidden = YES;
    }else
    {
        if (model.newMessage == 0) {
            cell.lblNewMeg.hidden = YES;
        }else
        {
            cell.lblNewMeg.hidden = NO;
            cell.lblNewMeg.text = [NSString stringWithFormat:@"%ld",model.newMessage];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientModel *model = _arryData[indexPath.row];

//    if (model.newMessage != 0) {
//        
//        NSDictionary *dicU = @{@"fromAccount":model.patientIM,@"toAccount":kDoctorIM};
//        [RequestManager CloseOnLine:[NSString stringWithFormat:@"%@/api/Share/SetQuestionMessageIsRead",NET_URLSTRING] Parameters:dicU Complation:^(NSNumber *code) {
//            if ([code integerValue]==10000) {
//                NSLog(@"免费咨询 已读");
//            }
//        } Fail:^(NSError *error) {
//            
//        }];
//    }
    
    if ([self.state isEqualToString:@"1"]) {
        NSDictionary *dicUpdate = @{@"state":@"2",@"questionId":model.questionId};
        //修改免费问诊状态
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/QuestionStateUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicUpdate viewConroller:self success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    FreeCahtViewController *patient = [[FreeCahtViewController alloc]init];
    patient.state = self.state;
    patient.patientModel = model;
    [self.navigationController pushViewController:patient animated:YES];
}

//富文本
-(NSMutableAttributedString *)setTextFree:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[text rangeOfString:strUnit]];
    return medStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------升序
-(NSArray *)shengXuPatientConFree:(NSArray *)arry{
    
    NSArray * array = [arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {

        NSDate *date1 = [_dateFormatter dateFromString:modelM1.modifyDate];
        NSDate *date2 = [_dateFormatter dateFromString:modelM2.modifyDate];
        NSComparisonResult result = [date2 compare:date1];
        return result == NSOrderedDescending;
    }];
    return array;
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
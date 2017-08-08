//
//  PCSInquiryViewController.m
//  HuaxiaPatient
//
//  Created by ydz on 17/2/23.
//  Copyright © 2017年 欧阳晓隆. All rights reserved.
//

#import "PCSInquiryViewController.h"
#import "PatientInfoListViewController.h"
#define IMAGE_NAME_MAN @"男1"
#define IMAGE_NAME_WOMAN @"女1"

@interface PCSInquiryViewController ()
{
    NSString *memberID;
    NSDateFormatter *formatter ;
}

@property (strong, nonatomic) IBOutlet UIView *view_pickDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePick_Date;

@property (weak, nonatomic) IBOutlet UITextField *NumOutpatient;

@property (weak, nonatomic) IBOutlet UILabel *lableStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lableEndDate;

@end

@implementation PCSInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self getDefaultData];

}

-(void)dealloc{

}

-(void)setNavigationBar
{
    self.title = @"PACS查询";

    self.view.backgroundColor =[ UIColor whiteColor];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    
}


-(void)getDefaultData{
    _lableStartDate.text = [formatter stringFromDate:[self getDateOneMothAgo]];
    _lableEndDate.text = [formatter stringFromDate:[NSDate date]];
}

-(NSDate *)getDateOneMothAgo{
    
    NSDateComponents *compon = [[NSDateComponents alloc]init];
    compon.month = -3;
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *next = [calender dateByAddingComponents:compon toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return next;
    
}

#pragma mark -------选择开始日期
- (IBAction)btnStartDate:(id)sender {
//    _datePick_Date.date = [self getDateOneMothAgo];
    [_NumOutpatient resignFirstResponder];
    [showAlertView showAlertviewWithView:_view_pickDate confirmAction:^{

        _lableStartDate.text = [formatter stringFromDate:[_datePick_Date date] ];
    }];

    
}

#pragma mark -------选择结束日期
- (IBAction)btnEndDate:(id)sender {
//    _datePick_Date.date = [formatter dateFromString:_lableEndDate.text];
    [_NumOutpatient resignFirstResponder];
    [showAlertView showAlertviewWithView:_view_pickDate confirmAction:^{

        _lableEndDate.text = [formatter stringFromDate:[_datePick_Date date]];
    }];
    
}


#pragma mark -------查询
- (IBAction)btnInquiry:(id)sender {
    
    [_NumOutpatient resignFirstResponder];
    
    NSString *patientId;
    if ([_NumOutpatient.text isEqualToString:@""]) {
        kAlter(@"请输入门诊号码！");
        return;
    }else
    {
        patientId = memberID;
    }
    
    NSDictionary *para = @{@"patientId":_NumOutpatient.text,@"SelBeginDate":_lableStartDate.text,@"SelEndDate":_lableEndDate.text};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/His/GetPatientExamList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject) {
        
        NSArray *arr = (NSArray *)responseObject;
        if (arr.count>0) {
            PatientInfoListViewController *info = [[PatientInfoListViewController alloc]init];
            info.arryData = arr;
            [self.navigationController pushViewController:info animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
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

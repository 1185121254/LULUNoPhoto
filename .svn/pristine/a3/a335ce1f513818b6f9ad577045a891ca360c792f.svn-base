//
//  KockPhoneNumberSettingViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockPhoneNumberSettingViewController.h"

@interface KockPhoneNumberSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn_PhoneSettingNext;
@property (weak, nonatomic) IBOutlet UIButton *btn_getPhoneMassage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_getPhoneMassage;
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;

@end

@implementation KockPhoneNumberSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    _btn_PhoneSettingNext.layer.masksToBounds = YES;
    _btn_PhoneSettingNext.layer.cornerRadius = 3;
    
    _lbl_getPhoneMassage.layer.masksToBounds=YES;
    _lbl_getPhoneMassage.layer.cornerRadius = 3;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取短信验证码
- (IBAction)btnActiongForGetMassage:(UIButton *)sender
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    NSString *telPhoneStr = userDic[@"tel"];
    
    //判断是否当前用户的手机
    if (![_txt_phone.text isEqualToString:telPhoneStr])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"输入正确的手机号"];
    }
    else
    {
        //判断验证码是否正确
        
    }
}



#pragma mark - 提交设置
- (IBAction)btnActionForPhoneNumBerStting:(UIButton *)sender
{
    
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

//
//  KockPhoneSelect.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockPhoneSelect.h"

@interface KockPhoneSelect ()
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;

@end

@implementation KockPhoneSelect

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)btnAction:(UIBarButtonItem *)sender
{
    if ([_txt_phone.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"手机不能为空"];
    }
    else
    {
        [self createPhone];
    }

}

#pragma mark - 发送手机号请求
-(void)createPhone
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    NSString *loginID;
    loginID = userDic[@"loginid"];
    [parameters setObject:loginID forKey:@"loginid"];
    [parameters setObject:_txt_phone.text forKey:@"tel"];
    
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
         //         NSLog(@"%@",responseObject);
         NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
         NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDeaults objectForKey:@"DoctorDataDic"]];
         [dic setObject:_txt_phone.text forKey:@"tel"];
         [userDeaults setObject:dic forKey:@"DoctorDataDic"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [self.navigationController popViewControllerAnimated:YES];
         [showAlertView showAlertViewWithMessage:@"设置成功"];
     } failure:^(NSError *error)
     {
         NSLog(@"错误 = %@",error);
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txt_phone.text = _strPhone;
    // Do any additional setup after loading the view.
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

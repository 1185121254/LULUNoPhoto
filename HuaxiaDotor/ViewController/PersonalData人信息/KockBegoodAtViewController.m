//
//  KockBegoodAtViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockBegoodAtViewController.h"

@interface KockBegoodAtViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text_info;

@end

@implementation KockBegoodAtViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.950];
}

- (IBAction)btnEnter:(UIBarButtonItem *)sender
{
    if ([_text_info.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"修改内容不能为空"];
    }
    else
    {
        [self createSpeciality];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


#pragma mark - 发送擅长请求
-(void)createSpeciality
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
    [parameters setObject:_text_info.text forKey:@"speciality"];
    
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
         //         NSLog(@"%@",responseObject);
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error)
     {
         NSLog(@"错误 = %@",error);
     }];
}

- (void)didReceiveMemoryWarning
{
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

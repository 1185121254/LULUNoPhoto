//
//  KockSexViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockSexViewController.h"

@interface KockSexViewController ()
@property (strong, nonatomic) NSString *str_sex;
@end

@implementation KockSexViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.950];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnSexAction:(UIButton *)sender
{
    if (sender.tag==20000)
    {
        _str_sex = @"女";
    }
    else if(sender.tag==10000)
    {
        _str_sex = @"男";
    }
}

#pragma mark - 完成性别修改
- (IBAction)btnActionEnter:(UIBarButtonItem *)sender
{
    if ([_str_sex isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"请选择性别"];
    }
    else
    {
        [self createSex];
    }
}

#pragma mark - 发送性别
-(void)createSex
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
    [parameters setObject:_str_sex forKey:@"sex"];
    
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
         //         NSLog(@"%@",responseObject);
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error)
     {
         NSLog(@"错误 = %@",error);
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

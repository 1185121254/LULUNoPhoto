//
//  HomeViewController.m
//  dawnEye
//
//  Created by KockPeter on 16/3/8.
//  Copyright © 2016年 kockPeter. All rights reserved.
//

#import "HomeViewController.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"


@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.view endEditing:YES];
    
    if ([kUserDefatuel objectForKey:@"id"]==nil) {
        [self goToLogin];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSString *loginID = [[kUserDefatuel objectForKey:@"DoctorDataDic"] objectForKey:@"loginid"];
    
    if (loginID!= nil) {
        //NIM自动登录
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
        [[[NIMSDK sharedSDK] loginManager] autoLogin:[NSString stringWithFormat:@"d%@",loginID] token:@"123456"];
    }
    

    
}

- (void)onLogin:(NIMLoginStep)step{
    NSLog(@"%ld",step);
}

- (void)onAutoLoginFailed:(NSError *)error{

}

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            [self goLogin:@"你的帐号被踢下线，请注意帐号信息安全"];
            break;
        }
        case NIMKickReasonByServer:{
            [self goLogin:@"你被服务器踢下线"];
        }
            break;
        default:
            break;
    }
}

-(void)goLogin:(NSString *)str{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"下线通知" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *log=[UIStoryboard storyboardWithName:@" LoginView" bundle:[NSBundle mainBundle]];
        LoginViewController *login=[log instantiateViewControllerWithIdentifier:@"LoginView"];
        login.from = @"exit";
        [self.navigationController pushViewController:login animated:YES];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)goToLogin{
    UIStoryboard *log=[UIStoryboard storyboardWithName:@" LoginView" bundle:[NSBundle mainBundle]];
    LoginViewController *login=[log instantiateViewControllerWithIdentifier:@"LoginView"];
    login.from = @"exit";
    [self.navigationController pushViewController:login animated:NO];
}

@end

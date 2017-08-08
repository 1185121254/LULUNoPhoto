//
//  KockDoctorintroduceViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockDoctorintroduceViewController.h"

@interface KockDoctorintroduceViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txt_introduce;

@end

@implementation KockDoctorintroduceViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.950];
}

- (IBAction)btnIntroduce:(UIBarButtonItem *)sender
{
    if ([_txt_introduce.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"介绍内容不能为空"];
    }
    else
    {
        [self createIntroduce];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txt_introduce.text = _str_introduce;
    self.view.backgroundColor = kBackgroundColor;
//     self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark - 发送介绍请求
-(void)createIntroduce
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
    [parameters setObject:_txt_introduce.text forKey:@"introduce"];
    
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
         //         NSLog(@"%@",responseObject);
         NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
         NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDeaults objectForKey:@"DoctorDataDic"]];
         [dic setObject:_txt_introduce.text forKey:@"introduce"];
         [userDeaults setObject:dic forKey:@"DoctorDataDic"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [self.navigationController popViewControllerAnimated:YES];
         [showAlertView showAlertViewWithMessage:@"设置成功"];
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
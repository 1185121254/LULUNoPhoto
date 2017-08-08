//
//  LonginViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "LoginViewController.h"
//#import "PersonalDataModel.h"
#import "HomeViewController.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"

@interface LoginViewController ()
//登录账号
@property (weak, nonatomic) IBOutlet UITextField *LonginNameText;
//登录密码
@property (weak, nonatomic) IBOutlet UITextField *LoginPassage;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;
//    _LoginPassage.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([kUserDefatuel objectForKey:@"loginName"]!=nil) {
        _LonginNameText.text = [kUserDefatuel objectForKey:@"loginName"];
    }
    if ([kUserDefatuel objectForKey:@"loginPassWorld"]!= nil) {
        _LoginPassage.text = [kUserDefatuel objectForKey:@"loginPassWorld"];
    }
   
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.hidden = YES;
    btnRight.frame = CGRectMake(0, 0, 40, 40);
    if ([NET_URLSTRING isEqualToString:@"http://liookun.imwork.net:90"]) {
        [btnRight setTitle:@"外" forState:UIControlStateNormal];
    }else if ([NET_URLSTRING isEqualToString:@"http://192.168.1.100:90"]){
        [btnRight setTitle:@"内" forState:UIControlStateNormal];
    }
    else if ([NET_URLSTRING isEqualToString:@"http://www.yanketong.com:90"]){
        [btnRight setTitle:@"正式" forState:UIControlStateNormal];
    }else
    {
        [btnRight setTitle:@"无网" forState:UIControlStateNormal];
    }
    [btnRight addTarget:self action:@selector(onChangeUrl:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.hidden = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
    
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.loginBtn.layer.masksToBounds=YES;
    self.loginBtn.layer.cornerRadius=3;
}

//登录按钮
- (IBAction)LogingActionBtn:(UIButton *)sender
{
    //判断是否为空
    if ([self.LonginNameText.text isEqualToString:@""])
    {
        kAlter(@"登录账号不能为空");
    }
    else if ([self.LoginPassage.text isEqualToString:@""]){
        kAlter(@"登录密码不能为空");
    }
    else
    {
        [self createLoginRequest:self.LonginNameText.text PassWord:self.LoginPassage.text];
    }
}

- (void)onChangeUrl:(UIButton *)btn{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    static NSInteger i=0;
    if (i%3==0)
    {
         [userdefault setObject:[NSString stringWithFormat:@"http://192.168.1.100:90"] forKey:@"ChangeURL"];
        [btn setTitle:@"内" forState:UIControlStateNormal];

    }
    else if(i%3==1){
        [userdefault setObject:[NSString stringWithFormat:@"http://liookun.imwork.net:90"] forKey:@"ChangeURL"];
        [btn setTitle:@"外" forState:UIControlStateNormal];
    }else
    {
        [userdefault setObject:[NSString stringWithFormat:@"http://www.yanketong.com:90"] forKey:@"ChangeURL"];
        [btn setTitle:@"正式" forState:UIControlStateNormal];

    }
    i++;
    if (i == 3) {
        i= 0;
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 登录请求
-(void)createLoginRequest:(NSString *)longinName PassWord:(NSString *)loginPassage
{
    //设置登录参数
    NSDictionary *paramerter = @{RESPONSE_KEY_LOGIN_ID:longinName,RESPONSE_KEY_LOGIN_PASSWORD:loginPassage};
    //    NSDictionary *paramerter = @{RESPONSE_KEY_LOGIN_ID:@"10002",RESPONSE_KEY_LOGIN_PASSWORD:@"123"};
    //POST请求
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载";
    _HUD.hidden = NO;
    [RequestManager postWithURLString:LOGIN_URLSTRING parameters:paramerter success:^(id responseObject){
        NSDictionary *dic = (NSDictionary *)responseObject;
        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"+++:%@",dic);
        

        NSString *code = [dic objectForKey:RESPONSE_KEY_CODE];
        _HUD.hidden = YES;
        //判断是否成功
        if ([code integerValue]==RESPONSE_CODE_SUCCESS)
        {
            dic = [dic objectForKey:RESPONSE_KEY_VALUE];
            //创建个人信息
            //用户verifyCode
            NSString *verifyCode=[dic objectForKey:RESPONSE_KEY_VERIFYCODE];
            //用户ID
            NSString *ID=[dic objectForKey:@"id"];
            NSArray *arryV = [dic objectForKey:@"VasSet"];
            [kUserDefatuel setObject:arryV[0] forKey:@"VasSet0"];
            [kUserDefatuel setObject:arryV[1] forKey:@"VasSet1"];
            [kUserDefatuel setObject:arryV[2] forKey:@"VasSet2"];
            [kUserDefatuel setObject:arryV[3] forKey:@"VasSet3"];

            //用userdefault存入verifyCode和ID
            NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
            //验证码
            [userDeaults setObject:verifyCode forKey:@"verifyCode"];
            //医生ID
            [userDeaults setObject:ID forKey:@"id"];
            //登录成功后获取到的字典信息
            [userDeaults setObject:dic forKey:@"DoctorDataDic"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //友盟
            [MobClick profileSignInWithPUID:[dic objectForKey:@"loginid"]];

            //登录云信
            [[[NIMSDK sharedSDK] loginManager] login:[NSString stringWithFormat:@"d%@",[dic objectForKey:@"loginid"]] token:@"123456" completion:^(NSError *error) {
                //登录成功前往首页
                [self createPushHomeView];
            }];
        }
        else if([code integerValue]!=RESPONSE_CODE_SUCCESS)
        {
            _HUD.hidden = YES;
            //提示错误信息

            kAlter(responseObject[@"message"]);
            _LoginPassage.text = @"";

        }
    } failure:^(NSError *error)
    {
        _HUD.hidden = YES;
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _HUD.hidden = YES;
        }]];
        [self presentViewController:alter animated:YES completion:nil];
        return ;
    }];
}

#pragma mark - 跳转到首页中
-(void)createPushHomeView
{
    
    [kUserDefatuel setObject:_LonginNameText.text forKey:@"loginName"];
    [kUserDefatuel setObject:_LoginPassage.text forKey:@"loginPassWorld"];
    
//    if ([self.from isEqualToString:@"exit"]) {
        NSArray *arry = self.navigationController.viewControllers;
        HomeViewController *home = arry[0];
        home.selectedIndex = 0;
        [self.navigationController popToViewController:home animated:YES];
//    }
//    else if([self.from isEqualToString:@"first"]){
//        
//        
//        
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)autoLogin:(NIMAutoLoginData *)loginData{


}


//立即注册账号
- (IBAction)createUser:(UIButton *)sender
{
    
}

//忘记密码
- (IBAction)forgoPassword:(UIButton *)sender
{
    
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

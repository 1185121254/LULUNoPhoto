//
//  RegisterViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "RegisterViewController.h"
#import "FDAlertView.h"
#import "FDConnectView.h"
//倒数时间
#define COUNT_BACKWARDS 59
#define ERROR_MESSAGE_PHONENUM @"手机号位数错误!(11位)"

@interface RegisterViewController ()
{
    MBProgressHUD *_HUD;
    NSMutableString *strCode;
    NSMutableString *oldCode;
    FDConnectView *contentView;
    BOOL isShowing;
}
//是否显示密码额按钮
@property (weak, nonatomic) IBOutlet UIButton *showPassword;
//密码文本框
@property (weak, nonatomic) IBOutlet UITextField *password;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *useMassage;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *useMassageBtn;
@property (weak, nonatomic) IBOutlet UILabel *useMassageLabel;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *telPhoneNum;
//倒数时间
@property (assign, nonatomic) NSTimer *timer;
//截止时间
@property (assign, nonatomic) NSInteger countDown;
//短信验证码
@property (copy, nonatomic) NSString *massageCode;

@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@property (nonatomic, strong) FDAlertView *fd;

@property (weak, nonatomic) IBOutlet UITextField *intiveCode;


@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //去掉返回按钮字体
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    //设置导航栏字体颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.useMassageBtn.layer.masksToBounds=YES;
    self.useMassageBtn.layer.cornerRadius=5;
    
    //是否显示密码
    self.showPassword.tag=100;
    self.password.secureTextEntry=YES;
    
    self.createBtn.layer.masksToBounds=YES;
    self.createBtn.layer.cornerRadius=3;
    
    self.useMassageLabel.layer.masksToBounds=YES;
    self.useMassageLabel.layer.cornerRadius=3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotify:) name:@"changeSecurityCode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOnNotify) name:@"cancelCodeSecurity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureOnNotify:) name:@"sureCodeSecurity" object:nil];


}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSecurityCode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelCodeSecurity" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sureCodeSecurity" object:nil];

}

//是否显示密码的按钮
- (IBAction)showPassWord:(UIButton *)sender
{
    //显示密码tag为110,不显示密码tag为100
    switch (sender.tag)
    {
        case 100:
        [self.showPassword setImage:[UIImage imageNamed:@"ic_login_visible"] forState:UIControlStateNormal];
        self.password.secureTextEntry=NO;
        self.showPassword.tag=110;
            break;
        case 110:
        [self.showPassword setImage:[UIImage imageNamed:@"ic_login_invisible"] forState:UIControlStateNormal];
        self.password.secureTextEntry=YES;
        self.showPassword.tag=100;
        default:
            break;
    }
}

#pragma mark - 获取验证码按钮
- (IBAction)securityCode:(UIButton *)sender
{
    
    if (self.telPhoneNum.text ==nil ||[self.telPhoneNum.text isEqualToString:@""]) {
        kAlter(@"请输入手机号码");
        return;
    }
    
    //获取手机号
    NSString *phoneNum = self.telPhoneNum.text?self.telPhoneNum.text:@"";
    //不为11位提示
    if (phoneNum.length!=11)
    {
        kAlter(ERROR_MESSAGE_PHONENUM);
    }
    else
    {
        //请求验证码
        [self GetCodefornMassge];

    }
}


#pragma mark------- 请求验证码
-(void)GetCodefornMassge
{
    
    [_telPhoneNum resignFirstResponder];
    
    NSDictionary *para = @{@"type":@"3",@"Loginid":_telPhoneNum.text};
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetVerificationReal",NET_URLSTRING] heads:nil parameters:para viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        strCode = (NSMutableString *)responseObject;
        
        if ([strCode isEqualToString:oldCode]) {
            return ;
        }
        NSLog(@"------%@",responseObject);
        
        if (isShowing == NO) {
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2];
        }else{
            [self changeCode];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)delayMethod{
    
    if (isShowing == NO) {
        isShowing = YES;
        if (self.fd == nil) {
            self.fd = [[FDAlertView alloc]init];;
            
            contentView = [[NSBundle mainBundle] loadNibNamed:@"FDConnectView" owner:nil options:nil].lastObject;
            
            self.fd.contentView = contentView;
            self.fd.contentView.frame = CGRectMake((kWith-kWith*4/5)/2, contentView.frame.origin.y, kWith*4/5, self.fd.contentView.frame.size.height);
        }

        [self.fd show];
        
    }else
    {
        NSLog(@"----------");
    }
    [self changeCode];
}

-(void)changeCode{

    contentView.strCodeSecurity = strCode;

}

-(void)onNotify:(NSNotification *)notyfy{
    
    oldCode = (NSMutableString *)notyfy.object;
    [self GetCodefornMassge];
    
}

-(void)cancelOnNotify{
    isShowing = NO;
    [self.fd hide];
    contentView.securityCodeFiled.text = @"";
}

-(void)sureOnNotify:(NSNotification *)notyfy{
    isShowing = NO;
    [self.fd hide];
    contentView.securityCodeFiled.text = @"";
    
    if ([(NSString *)notyfy.object caseInsensitiveCompare:strCode] != NSOrderedSame) {
        kAlter(@"验证码输入错误!");
        return;
    }
    
    [self getCodeFromNet];
}

-(void)getCodeFromNet{
    
    
    NSDictionary *dic = @{RESPONSE_KEY_LOGIN_ID:self.telPhoneNum.text,@"type":@"3",@"VerificationReal":strCode};
    [RequestManager postWithURLString:GET_USERCODE_MASSAGE parameters:dic success:^(id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dic=(NSDictionary *)responseObject;
             //判断网络请求是否成功
             NSNumber *code =[dic objectForKey:RESPONSE_KEY_CODE];
             if ([code integerValue]==RESPONSE_CODE_SUCCESS)
             {
                 kAlter(@"验证码正确，短信已发出");
                 
                 self.useMassageBtn.userInteractionEnabled = NO;

                 //关闭按钮
                 self.useMassageBtn.enabled = NO;
                 //设置时间
                 self.countDown=COUNT_BACKWARDS;
                 //设置初始时间
                 self.useMassageLabel.text=[NSString stringWithFormat:@"%d秒后重发",COUNT_BACKWARDS];
                 
                 self.massageCode=[NSString stringWithFormat:@"%@",[dic objectForKey:RESPONSE_KEY_VALUE]];
                 //开始倒计时
                 self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountMethod) userInfo:nil repeats:YES];
             }
             else if ([code integerValue]==RESPONSE_CODE_FAILURE)
             {
                 self.useMassageBtn.userInteractionEnabled = YES;

                 kAlter([dic objectForKey:RESPONSE_KEY_MESSAGE]);
             }
         }
     } failure:^(NSError *error)
     {
         NSLog(@"error:%@",error);
     }];
}

//倒计时
-(void)timeCountMethod
{
    //再此倒计时
    self.countDown--;
    //设置倒计时显示
    self.useMassageLabel.text=[NSString stringWithFormat:@"%ld秒后重发",(long)self.countDown];
    self.useMassageLabel.textColor=[UIColor colorWithWhite:0.000 alpha:0.202];
    //设置按钮的风格
    self.useMassageBtn.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.500];
    self.useMassageLabel.textColor=[UIColor whiteColor];
    [self.useMassageBtn.layer setBorderColor:[UIColor colorWithWhite:0.000 alpha:0.199].CGColor];
    [self.useMassageBtn.layer setBorderWidth:1];
    self.useMassageBtn.layer.masksToBounds=YES;
    if (self.countDown==0)
    {
        [self.timer invalidate];
        self.timer = nil;
        //设置为默认按钮状态
        self.useMassageLabel.text=@"发送验证码";
        self.useMassageLabel.textColor=[UIColor whiteColor];
        self.useMassageBtn.backgroundColor=[UIColor colorWithRed:160/255.0 green:213/255.0 blue:104/255.0 alpha:1];
        [self.useMassageBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.useMassageBtn.layer setBorderWidth:1];
        self.useMassageBtn.layer.masksToBounds=YES;
        self.useMassageBtn.enabled=YES;
    }
}

//11   10     11

#pragma mark - 确定注册按钮
- (IBAction)registerButton:(UIButton *)sender
{
    //判断文本框内容是否为空
    [self createJudeTextStyle];

}

//提交注册信息
-(void)putInCreateUserInfo
{
    //把密码和用户转换字符串
    NSString *passwordString = self.password.text;
    NSString *userNameString = self.telPhoneNum.text;
    NSString *inviteCode;
    if (self.intiveCode.text == nil) {
        inviteCode = @"";
    }else{
        inviteCode = self.intiveCode.text;
    }
    //把用户名和密码放入字典中
    NSDictionary *parama = @{RESPONSE_KEY_LOGIN_ID:userNameString,RESPONSE_KEY_LOGIN_PASSWORD:passwordString,@"vercode":self.useMassage.text,@"InviteCode":inviteCode};
    //POST网络请求
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载";
    _HUD.hidden = NO;
    [RequestManager postWithURLString:REGISTER_USER parameters:parama success:^(id responseObject)
     {
         _HUD.hidden = YES;
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dic = (NSDictionary *)responseObject;
             NSNumber *code=[dic objectForKey:RESPONSE_KEY_CODE];
             if ([code integerValue]==RESPONSE_CODE_SUCCESS)
             {
                 //跳转到登录页面
                 [self alter];
             }
             else
             {
                 //错误初始massage
                 kAlter(dic[@"message"]);
             }
         }
    } failure:^(NSError *error)
    {
         _HUD.hidden = YES;
        kAlter(@"网络连接错误");
    }];
}

-(void)alter{

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
    
}

//判断手机 验证码 密码 是否为空 验证码是否正确 密码是否为6位
-(void)createJudeTextStyle
{
    //把本地的code和短信获取到的Code核对
//    int massage=[self.useMassage.text intValue];
//    int massageCode=[self.massageCode intValue];
    if ([self isPhone:self.telPhoneNum.text] == NO)
    {
        kAlter(@"手机号格式错误");
    }
    else
        if ([self.useMassage.text isEqualToString:@""]) {
        kAlter(@"请输入验证码");
    }

    else
        if (self.password.text.length<6)
    {
        kAlter(@"密码不能小于6位,请重新输入");
    }
    else
    {
        //提交注册信息
        [self putInCreateUserInfo];
    }
}

-(BOOL)isPhone:(NSString *)phone{
    NSString *MOBILE = @"^1[34578]\\d{9}$";
    NSPredicate *regexTestMobile = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    if (![regexTestMobile evaluateWithObject:phone]) {
        return NO;
    }
    return YES;
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

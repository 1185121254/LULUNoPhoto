//
//  forgetPassword.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/30.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "forgetPassword.h"
#import "FDAlertView.h"
#import "FDConnectView.h"
@interface forgetPassword ()
{
    NSMutableString *strCode;
    NSMutableString *oldCode;
    FDConnectView *contentView;
    BOOL isShowing;
}

@property (weak, nonatomic) IBOutlet UITextField *txt_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_Massage;
@property (weak, nonatomic) IBOutlet UITextField *txt_passWord;
@property (weak, nonatomic) IBOutlet UITextField *txt_passWordAgain;
@property (weak, nonatomic) IBOutlet UILabel *lbl_massage;
@property (weak, nonatomic) IBOutlet UIButton *btn_enter;
@property (strong, nonatomic) NSString *str_massageCode;//验证码
@property (assign, nonatomic) NSInteger countDown;//截止时间
@property (assign, nonatomic) NSTimer *timer;//倒数时间

@property (nonatomic, strong) FDAlertView *fd;
@property (weak, nonatomic) IBOutlet UIButton *userMessageBtnNo;


@end

@implementation forgetPassword

-(void)viewWillAppear:(BOOL)animated
{
    _lbl_massage.layer.cornerRadius = 5;
    [_lbl_massage.layer setMasksToBounds:YES];
    _btn_enter.layer.cornerRadius = 5;
    [_btn_enter.layer setMasksToBounds:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotify:) name:@"changeSecurityCode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOnNotify) name:@"cancelCodeSecurity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureOnNotify:) name:@"sureCodeSecurity" object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSecurityCode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelCodeSecurity" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sureCodeSecurity" object:nil];
    
}

#pragma mark - 验证短信
- (IBAction)getMassage:(UIButton *)sender
{

        if ([self valiMobile:_txt_phone.text])//判断电话是否正确
        {
            [self GetCodefornMassge];
        }
}

#pragma mark - 确定
- (IBAction)btn_actionEnter:(UIButton *)sender
{
    if ([_txt_phone.text isEqualToString:@""]||_txt_phone.text==nil) {
        kAlter(@"请输入手机号码");
    }
    else if ([_txt_Massage.text isEqualToString:@""]||_txt_Massage.text==nil)
    {
        kAlter(@"验证码不能为空");
    }
    else if ([_txt_passWord.text isEqualToString:@""])
    {
        kAlter(@"密码不能为空,请重新输入");
    }
    else if (_txt_passWord.text.length<6)
    {
        kAlter(@"密码不能少于6位,请重新输入");
    }
    else if (![_txt_passWord.text isEqualToString:_txt_passWordAgain.text])
    {
        kAlter(@"密码前后输入不一致,请重新输入");
    }
    else
    {
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:_txt_phone.text forKey:@"loginid"];
        [parameters setObject:_txt_passWordAgain.text forKey:@"password"];
        [parameters setObject:self.txt_Massage.text forKey:@"vercode"];
        [RequestManager postWithURLString:RESETPASSWORD parameters:parameters success:^(id responseObject)
         {
             int i = (int)[responseObject[@"code"] integerValue];
             NSString *massage = responseObject[@"message"];
             if (i == 10000)
             {
                 [self alterView];
             }
             else
             {
                 kAlter(massage);
             }
        } failure:^(NSError *error)
         {
            kAlter(@"修改失败");
        }];
    }
}

//请求验证码
-(void)GetCodefornMassge
{
    [_txt_phone resignFirstResponder];
    
    NSDictionary *para = @{@"type":@"4",@"Loginid":_txt_phone.text};
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
    
    if (![(NSString *)notyfy.object isEqualToString:strCode]) {
        kAlter(@"验证码输入错误!");
        return;
    }
    
    [self getCodeFromNEt];
}


-(void)getCodeFromNEt{
    
    NSDictionary *dicP = @{RESPONSE_KEY_LOGIN_ID:_txt_phone.text,@"type":@"4",@"VerificationReal":strCode};
    [RequestManager postWithURLString:GET_USERCODE_MASSAGE parameters:dicP success:^(id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dic=(NSDictionary *)responseObject;
             //判断网络请求是否成功
             NSNumber *code =[dic objectForKey:RESPONSE_KEY_CODE];
             if ([code integerValue]==RESPONSE_CODE_SUCCESS)
             {
                 self.userMessageBtnNo.userInteractionEnabled = NO;

                 kAlter(@"验证码正确，短信已发出");

                 _str_massageCode=[NSString stringWithFormat:@"%@",[dic objectForKey:RESPONSE_KEY_VALUE]];
                 
                 //开始倒计时
                 _lbl_massage.text = @"59秒后重发";
                 _countDown = 59;
                 _lbl_massage.enabled = NO;
                 _lbl_massage.textColor=[UIColor colorWithWhite:0.000 alpha:0.202];
                 //设置按钮的风格
                 _lbl_massage.backgroundColor=[UIColor colorWithWhite:0.750 alpha:1.000];
                 _lbl_massage.textColor=[UIColor whiteColor];
                 [_lbl_massage.layer setBorderColor:[UIColor colorWithWhite:0.000 alpha:0.199].CGColor];
                 [_lbl_massage.layer setBorderWidth:1];
                 _lbl_massage.layer.masksToBounds=YES;
                 
                 self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountMethod) userInfo:nil repeats:YES];

             }
             else if ([code integerValue]==RESPONSE_CODE_FAILURE)
             {
                 self.userMessageBtnNo.userInteractionEnabled = YES;

                 [showAlertView showAlertViewWithMessage:[dic objectForKey:RESPONSE_KEY_MESSAGE]];
             }
         }
     } failure:^(NSError *error)
     {
         [showAlertView showAlertViewWithOnlyMessage:@"网络错误,获取验证码失败"];
         NSLog(@"error:%@",error);
     }];

}

- (BOOL)valiMobile:(NSString *)mobile
{
    if (mobile == nil ||[mobile isEqualToString:@""]) {
        [showAlertView showAlertViewWithMessage:@"请输入手机号码"];
        return NO;
    }
    
    if (mobile.length < 11)
    {
        [showAlertView showAlertViewWithMessage:@"手机号长度只能是11位"];
        return NO;
    }
    else
    {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3)
        {
            return YES;
        }
        else
        {
            kAlter(@"请输入正确的手机号码");
            return NO;
        }
    }
}

//倒计时
-(void)timeCountMethod
{
    //再此倒计时
    self.countDown--;
    //设置倒计时显示
    _lbl_massage.text=[NSString stringWithFormat:@"%ld秒后重发",(long)self.countDown];
    _lbl_massage.textColor=[UIColor colorWithWhite:0.000 alpha:0.202];
    //设置按钮的风格
    _lbl_massage.backgroundColor=[UIColor colorWithWhite:0.750 alpha:1.000];
    _lbl_massage.textColor=[UIColor whiteColor];
    [_lbl_massage.layer setBorderColor:[UIColor colorWithWhite:0.000 alpha:0.199].CGColor];
    [_lbl_massage.layer setBorderWidth:1];
    _lbl_massage.layer.masksToBounds=YES;
    if (self.countDown==0)
    {
        [self.timer invalidate];
        self.timer = nil;
        //设置为默认按钮状态
        _lbl_massage.text=@"发送验证码";
        _lbl_massage.textColor=[UIColor whiteColor];
        _lbl_massage.backgroundColor=[UIColor colorWithRed:160/255.0 green:213/255.0 blue:104/255.0 alpha:1];
        [_lbl_massage.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_lbl_massage.layer setBorderWidth:1];
        _lbl_massage.layer.masksToBounds=YES;
        _lbl_massage.enabled=YES;
    }
}

-(void)alterView{

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码重置成功,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

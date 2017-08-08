//
//  ZhifubaoViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ZhifubaoViewController.h"

@interface ZhifubaoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_count;
@property (strong, nonatomic) NSString *str_doctorID;
@property (strong, nonatomic) NSString *str_verifyCode;
//解除
@property (weak, nonatomic) IBOutlet UIButton *btnUnchain;
//绑定
@property (weak, nonatomic) IBOutlet UIButton *btnBound;

@property(nonatomic,assign) BOOL isBingling;

@end

@implementation ZhifubaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    
    _lbl_name.text = userDic[@"userName"];
    _str_doctorID = userDic[@"id"];
    _str_verifyCode = userDic[@"verifyCode"];
    
    //获取是否绑定了支付宝
    [self getZhifubaoData];

}

#pragma mark - 判断是否绑定了支付宝
-(void)getZhifubaoData
{
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:_str_verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:_str_doctorID forKey:@"doctorId"];
    //GET
    [RequestManager getWithURLString:GETPayAccount heads:heads parameters:parameters success:^(id responseObject)
     {
         NSDictionary *dic = responseObject[@"value"];
         
         if (dic[@"payAccount"]) {
             //已经绑定
             _isBingling = YES;
             _txt_count.text = dic[@"payAccount"];
             
         }
         else
         {
            //未绑定
             _isBingling = NO;
             _txt_count.text = @"";
         
         }
         
         [self isBoundling:_isBingling];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 解除绑定
- (IBAction)btnActionUnchain:(UIButton *)sender
{
    if (_isBingling == YES) {
        [self setTipAlter];
    }else
    {
        kAlter(@"请先绑定一个支付宝账户");
    }
}

#pragma mark - 取消支付宝绑定请求
-(void)unchainZhifubao
{
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:_str_verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:_str_doctorID forKey:@"Id"];

    //GET
    [RequestManager getWithURLString:PAYACCOUNTCANTCEL heads:heads parameters:parameters success:^(id responseObject)
     {
         NSDictionary *dic = (NSDictionary *)responseObject;
         if ([[dic objectForKey:@"code"] integerValue]==10000) {
             kAlter(@"成功取消绑定");
             _isBingling = NO;
             _txt_count.text = @"";
             [self isBoundling:_isBingling];

         }else
         {
             kAlter(@"解绑失败");
         }
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 绑定
- (IBAction)btnActionBound:(UIButton *)sender
{
    if ([_txt_count.text isEqualToString:@""])
    {
        kAlter(@"账号信息不能为空");
    }
    else
    {
        if (_isBingling == NO) {
            [self postBoundToZhiFuBao];
        }else
        {
            kAlter(@"不能重复绑定");
        }
    }
}

#pragma mark - 绑定
-(void)postBoundToZhiFuBao
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    _str_verifyCode=[userdefault objectForKey:@"verifyCode"];
    //POST
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:_str_verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //医生ID
    [parameters setObject:_str_doctorID forKey:@"doctorId"];
    //支付账号
    [parameters setObject:_txt_count.text forKey:@"payAccount"];
    //医生姓名
    [parameters setObject:_lbl_name.text forKey:@"Name"];
    
    [RequestManager postWithURLString:ZHIFUBAOACCONUNT heads:heads parameters:parameters success:^(id responseObject)
     {
         
         NSDictionary *dic = (NSDictionary *)responseObject;
         if ([dic objectForKey:@"payAccount"]) {
             kAlter(@"绑定成功");
             _isBingling = YES;
             [self isBoundling:_isBingling];
         }else
         {
             kAlter(@"绑定失败");
         }
         
     } failure:^(NSError *error){
         NSLog(@"错误 = %@",error);
     }];
}

#pragma mark - 按钮选择状态
-(void)isBoundling:(BOOL)select
{
    if (select==YES)
    {
        _btnUnchain.layer.cornerRadius = 5;
        _btnUnchain.layer.masksToBounds = YES;
        _btnUnchain.backgroundColor = BLUECOLOR_STYLE;
        [_btnUnchain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnUnchain.layer setBorderWidth:0];
        [_btnUnchain.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        _btnBound.layer.cornerRadius = 5;
        _btnBound.layer.masksToBounds = YES;
        [_btnBound.layer setBorderWidth:1];
        [_btnBound.layer setBorderColor:[[UIColor colorWithWhite:1.000 alpha:0.955] CGColor]];
        _btnBound.backgroundColor = [UIColor whiteColor];
        [_btnBound setTitleColor:[UIColor colorWithWhite:0.000 alpha:0.500] forState:UIControlStateNormal];
        [_btnBound.layer setBorderColor: [[UIColor colorWithWhite:0.000 alpha:0.500]CGColor]];
        
    }
    else
    {
        _btnUnchain.layer.cornerRadius = 5;
        _btnUnchain.layer.masksToBounds = YES;
        [_btnUnchain.layer setBorderWidth:1];
        [_btnUnchain.layer setBorderColor:[[UIColor colorWithWhite:1.000 alpha:0.955] CGColor]];
        _btnUnchain.backgroundColor = [UIColor whiteColor];
        [_btnUnchain setTitleColor:[UIColor colorWithWhite:0.000 alpha:0.500] forState:UIControlStateNormal];
        [_btnUnchain.layer setBorderColor: [[UIColor colorWithWhite:0.000 alpha:0.500]CGColor]];
        
        _btnBound.layer.cornerRadius = 5;
        _btnBound.layer.masksToBounds = YES;
        _btnBound.backgroundColor = BLUECOLOR_STYLE;
        [_btnBound setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnBound.layer setBorderWidth:0];
        [_btnBound.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    }
}

-(void)setTipAlter{

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"继续解除绑定该支付宝账户" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self unchainZhifubao];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
    
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

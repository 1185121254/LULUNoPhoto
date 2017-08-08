//
//  PersonalInfoDataViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PersonalInfoDataViewController.h"
#import "KockImagePickSelect.h"

@interface PersonalInfoDataViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sex;
@property (weak, nonatomic) IBOutlet UILabel *lbl_borthData;
@property (weak, nonatomic) IBOutlet UILabel *lbl_begoodAt;
//认证
@property (weak, nonatomic) IBOutlet UILabel *lbl_approve;
//介绍
@property (weak, nonatomic) IBOutlet UILabel *lbl_referral;

@end

@implementation PersonalInfoDataViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.945];
    self.navigationController.navigationBarHidden = NO;
//    NSLog(@"%@",_dic_doctorData);
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,_dic_doctorData[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl]];
    _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
    [_image_head.layer setMasksToBounds:YES];

    _lbl_name.text = _dic_doctorData[@"userName"];
    int int_sex = [_dic_doctorData[@"sex"] integerValue];
    if (int_sex==1)
    {
        _lbl_sex.text=@"男";
    }
    else if (int_sex==0)
    {
         _lbl_sex.text=@"女";
    }
    _lbl_borthData.text = _dic_doctorData[@"birthDay"];
    _lbl_begoodAt.text = _dic_doctorData[@"speciality"];
    _lbl_approve.text = _dic_doctorData[@"licenseTitle"];
    _lbl_referral.text = _dic_doctorData[@"introduce"];
    
    //注册监听者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImage:) name:@"setImageForHead" object:nil];
    
    //移除图片的图层
    if (self.childViewControllers.count!=0)
    {
        KockImagePickSelect *selectImage = self.childViewControllers[0];
        if ([selectImage isKindOfClass:[KockImagePickSelect class]])
        {
            [selectImage.view removeFromSuperview];
            [selectImage removeFromParentViewController];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - 设置头像 调用selectPickview
- (IBAction)setHeadAction:(UIButton *)sender
{
    KockImagePickSelect *imageSetting = [[KockImagePickSelect alloc]init];
    imageSetting.view.frame = self.view.frame;
    [self.view addSubview:imageSetting.view];
    [self addChildViewController:imageSetting];
}

#pragma mark - 设置姓名
- (IBAction)setNameAction:(UIButton *)sender
{
    
}

#pragma mark - 设置性别
- (IBAction)setSexAction:(UIButton*)sender
{
    
}

#pragma mark - 设置出生日期
- (IBAction)setBorthDate:(UIButton *)sender
{
    [self pickViewShow];
}

#pragma mark - 设置擅长
- (IBAction)beGoodAtAction:(UIButton *)sender
{
    
}

#pragma mark - 认证
- (IBAction)approveAction:(UIButton *)sender
{
    
}

#pragma mark - 介绍
- (IBAction)referralAction:(UIButton *)sender
{
    
}

#pragma mark 响应监听通知的方法 (收到通知后的操作)
-(void)setImage:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    _image_head.image = dict[@"imageHead"];
    [self postImageSent];
}

#pragma mark - 提交图片改变请求
-(void)postImageSent
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userdefault objectForKey:@"verifyCode"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置头文件
    [manager.requestSerializer setValue:verifyCode forHTTPHeaderField:@"verifyCode"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //创建字典存放数据
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    [manager POST:SETTINGHEADIMAGE parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        NSData *imageData = UIImageJPEGRepresentation(_image_head.image, 1.0);
        [formData appendPartWithFileData:imageData name:@"File" fileName:@"headImage" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [showAlertView showAlertViewWithMessage:@"头像设置成功"];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
}

#pragma mark - 时间选择器点击事件
-(void)pickViewShow
{
    //创建遮盖试图
    UIView *shadeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    shadeView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.301];
    [self.view addSubview:shadeView];
    
    //创建时间滚轮
    UIDatePicker *datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 250,120)];
    //    datePickerView.backgroundColor=BLUECOLOR_STYLE;
    //锁定为中文
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datePickerView.locale=locale;
    //时间模式
    datePickerView.datePickerMode=UIDatePickerModeDate;
    //时间间隔
    datePickerView.minuteInterval = 30;
    
    //创建提示框
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil contentView:datePickerView cancelButtonTitle:nil];
    [cxAlertView addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];

                                //截取时间
                                NSDate *select=[datePickerView date];
                                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                                [dateFormatter setDateFormat:@"yyy-mm-dd"];
                                NSString *dateTime=[dateFormatter stringFromDate:select];
                                [self sentBorthDay:dateTime];
                            }];
    [cxAlertView addButtonWithTitle:@"取消"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                            }];
    cxAlertView.showBlurBackground = NO;
    [cxAlertView show];
}

#pragma mark - 时间修改
-(void)sentBorthDay:(NSString *)dateTime
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    //POST
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:userDic[@"loginid"] forKey:@"loginid"];
    [parameters setObject:dateTime forKey:@"birthDay"];
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
        [showAlertView showAlertViewWithMessage:@"修改成功"];
    } failure:^(NSError *error)
    {
        NSLog(@"错误 = %@",error);
    }];
}

-(void)dealloc
{
    //移除当前的通知对象
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setImageForHead" object:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  KNewPatientAddCaseViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KNewPatientAddCaseViewController.h"
//多选图片三方类
#import "ImportPatientViewController.h"

#import "AddImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
//语音
#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
@interface KNewPatientAddCaseViewController ()<ViewSendImageArrDelegate,IFlyRecognizerViewDelegate>
//标题
@property (weak, nonatomic) IBOutlet UITextField *txt_title;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
//男女按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *image_man;
@property (weak, nonatomic) IBOutlet UIImageView *image_woman;
//男女按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_man;
@property (weak, nonatomic) IBOutlet UIButton *btn_woman;
@property (assign, nonatomic) int isSexSelect;
//性别
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
//疾病诊断
@property (weak, nonatomic) IBOutlet UITextField *txt_diagnose;
//诊断容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_diagnose;
//症状描述
@property (weak, nonatomic) IBOutlet UITextField *txt_symptom;
//症状描述高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_symptom;
//备注
@property (weak, nonatomic) IBOutlet UITextField *txt_mark;
//备注高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_mark;
//添加图片容器
@property (weak, nonatomic) IBOutlet UIView *image_add;
//添加图片容器的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_imageAdd;
@property (strong, nonatomic) NSMutableArray *imageData;
@property (weak, nonatomic) IBOutlet UIView *PatientNewScrollerView;
//滚动试图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerViewforPatient;
//滚动试图的的view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollerContanView;

//语音图
@property (strong, nonatomic) IFlyRecognizerView *iflyRecognizerView;
//判断  1:疾病诊断  2:症状描述按钮 3:备注按钮
@property (assign, nonatomic) int style;

@property (strong, nonatomic) NSArray *arr_picList;

@end

@implementation KNewPatientAddCaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.dicData != nil) {
        
        _txt_name.text = [self.dicData objectForKey:@"name"];
        _txtAge.text = [NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"age"]];
        _txt_diagnose.text = [self.dicData objectForKey:@"description"];
        _txt_symptom.text = [self.dicData objectForKey:@"illDetail"];
        if ([[self.dicData objectForKey:@"sex"] integerValue]==1) {
            _btn_man.selected = YES;
            [_image_man setImage:[UIImage imageNamed:@"i圈_h"]];
            [_image_woman setImage:[UIImage imageNamed:@"i圈"]];
            _btn_woman.selected = NO;
        }else
        {
            _btn_woman.selected = YES;
            [_image_man setImage:[UIImage imageNamed:@"i圈"]];
            [_image_woman setImage:[UIImage imageNamed:@"i圈_h"]];
            _btn_man.selected = NO;
        }
    }else
    {
        //性别默认男
        _isSexSelect = 1;
        [_image_man setImage:[UIImage imageNamed:@"i圈_h"]];
    }
    _arr_picList = [[NSMutableArray alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AddImage *image = [[AddImage alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, _image_add.frame.size.height) withViewController:self];
    [_image_add addSubview:image];
    
    UIBarButtonItem *rightimp = [[UIBarButtonItem alloc] initWithTitle:@"导入病历" style:UIBarButtonItemStylePlain target:self action:@selector(onRightIport)];
    self.navigationItem.rightBarButtonItem = rightimp;
}

#pragma mark - 三方图片多选的代理方法
-(void)ViewSendImageArr:(NSMutableArray *)imageArr andMaxCount:(NSInteger)maxCount
{
    NSInteger imageCount = imageArr.count;
    _imageData = [[NSMutableArray alloc]init];
    _imageData = imageArr;
    if (imageCount<maxCount)
    {
        _height_imageAdd.constant = 85;
        _scrollerViewforPatient.contentSize = CGSizeMake(SCREEN_W, _PatientNewScrollerView.frame.size.height+85);
    }
    else if((imageCount>=maxCount)&&(imageCount<maxCount*2))
    {
        _height_imageAdd.constant = 85*2;
        _scrollerViewforPatient.contentSize = CGSizeMake(SCREEN_W, _PatientNewScrollerView.frame.size.height+85*2);
    }
    else
    {
        _height_imageAdd.constant = 85*3;
        _scrollerViewforPatient.contentSize = CGSizeMake(SCREEN_W, _PatientNewScrollerView.frame.size.height+85*3);
    }
    
    //上传图片的请求
    [self updatePic:imageArr];
}

#pragma mark - 上传图片的请求
-(void)updatePic:(NSMutableArray*)arr
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //设置头文件
    [manager.requestSerializer setValue:verifyCode forHTTPHeaderField:@"verifyCode"];

    [manager POST:PICTUREUPLOAD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         for (int i=0; i<_imageData.count; i++)
         {
             ALAsset *asset=_imageData[i];
             CGImageRef posterImageRef=[asset aspectRatioThumbnail];
             UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
             UIImage *image = posterImage;
             NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
             [formData appendPartWithFileData:imageData name:@"File" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpeg"];
         }
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         _arr_picList = responseObject[@"value"];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         kReuestFaile;
     }];
    
}

#pragma mark - 男10000  女10001
- (IBAction)btnActionSex:(UIButton *)sender
{
    if (sender.tag==10000)
    {
        _image_man.image = [UIImage imageNamed:@"i圈_h"];
        _image_woman.image = [UIImage imageNamed:@"i圈"];
        _isSexSelect = 1;
    }
    else if (sender.tag==10001)
    {
        _image_man.image = [UIImage imageNamed:@"i圈"];
        _image_woman.image = [UIImage imageNamed:@"i圈_h"];
        _isSexSelect = 0;
    }
}
#pragma mark - 疾病诊断
- (IBAction)btnAction_ill:(UIButton *)sender
{
    [self onNotifyXunFlyClip];
    _style = 1;
}

#pragma mark - 症状描述按钮
- (IBAction)btnAction_symptom:(UIButton *)sender
{
    [self onNotifyXunFlyClip];
    _style = 2;
}

#pragma mark - 备注按钮
- (IBAction)btnAction_mark:(UIButton *)sender
{
    [self onNotifyXunFlyClip];
    _style = 3;
}

#pragma mark----------讯飞
-(void)onNotifyXunFlyClip
{
    
    if (_iflyRecognizerView == nil)
    {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    }
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //启动识别服务
    [_iflyRecognizerView start];
}
-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    
    NSString *str = [[resultArray lastObject] allKeys][0];
    if ([str isEqualToString:@"。"])
    {
        return;
    }
    else if (_style==1)
    {
        _txt_diagnose.text = str;
    }
    else if(_style==2)
    {
        _txt_symptom.text = str;
    }
    else if (_style==3)
    {
        _txt_mark.text = str;
    }
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}

#pragma mark - 发布患者病例
- (IBAction)btnActionSendNew:(UIButton *)sender
{
    //年龄为数字
    NSString *ageStr = _txtAge.text;
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:ageStr])
    {
        kAlter(@"年龄只能是数字！");
        return;
    }
    if ([_txt_title.text isEqualToString:@""]||_txt_title.text==nil)
    {
        [showAlertView showAlertViewWithOnlyMessage:@"标题不能为空"];
    }
    else if ([_txt_name.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"患者姓名不能为空"];
    }
    else if ([_txtAge.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"患者年纪不能为空"];
    }
    else if ([_txt_diagnose.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"疾病诊断不能为空"];
    }
    else if ([_txt_symptom.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"症状不能为空"];
    }
    //    else if ([_txt_mark.text isEqualToString:@""])
    //    {
    //        [showAlertView showAlertViewWithOnlyMessage:@"备注不能为空"];
    //    }
    else
    {
        //发布会诊
        [self sendPatient];
    }
}

#pragma mark - 发布会诊
-(void)sendPatient
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //话题标题
    [parameters setObject:_txt_title.text forKey:@"title"];
    //备注
    [parameters setObject:_txt_mark.text forKey:@"detail"];
    //医生ID
    [parameters setObject:userID forKey:@"doctorId"];
    //患者姓名
    [parameters setObject:_txt_name.text forKey:@"patientName"];
    //性别
    [parameters setObject:[NSString stringWithFormat:@"%d",_isSexSelect] forKey:@"sex"];
    //年龄
    [parameters setObject:_txtAge.text forKey:@"age"];
    //病情诊断
    [parameters setObject:_txt_diagnose.text forKey:@"illness"];
    //病状描述
    [parameters setObject:_txt_symptom.text forKey:@"illDetail"];
    //图片集合
    [parameters setObject:_arr_picList forKey:@"picList"];
    
    [RequestManager postWithURLString:NETCONSULTATIONADD heads:heads parameters:parameters success:^(id responseObject)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [showAlertView showAlertViewWithMessage:@"添加成功"];
    } failure:^(NSError *error) {
        kReuestFaile;
    }];
}

//#pragma mark - 上传新的患者数据 POST  有图片
//-(void)sendNewPatient
//{
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    //获取用户秘钥
//    NSString *verifyCode;
//    verifyCode=[userDefaults objectForKey:@"verifyCode"];
//    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    //设置头文件
//    [manager.requestSerializer setValue:verifyCode forHTTPHeaderField:@"verifyCode"];
//    //话题标题
//    [manager.requestSerializer setValue: [_txt_title.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"title"];
//    //备注
//    [manager.requestSerializer setValue:[_txt_mark.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"detail"];
//    //患者姓名
//    [manager.requestSerializer setValue:[_txt_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"patientName"];
//    //性别
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d",_isSexSelect] forHTTPHeaderField:@"sex"];
//    //年龄
//    [manager.requestSerializer setValue:[_txtAge.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"age"];
//    //病情诊断
//    [manager.requestSerializer setValue:[_txt_diagnose.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"illness"];
//    //病状描述
//    [manager.requestSerializer setValue:[_txt_symptom.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"illDetail"];
//    
//    //创建字典存放数据
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
//    [parameters setObject:@"11" forKey:@"ddd"];
//    [manager POST:NETCONSULTATIONADD parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
//    {
//        for (int i=0; i<_imageData.count; i++)
//        {
//            ALAsset *asset=_imageData[i];
//            CGImageRef posterImageRef=[asset aspectRatioThumbnail];
//            UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
//            UIImage *image = posterImage;
//            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//            [formData appendPartWithFileData:imageData name:@"File" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpeg"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self.navigationController popViewControllerAnimated:YES];
//        [showAlertView showAlertViewWithMessage:@"添加成功"];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}

//#pragma mark - 上传新的患者数据 POST  无图片
//-(void)sendNewPatientNoimageee
//{
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    //获取用户秘钥
//    NSString *verifyCode;
//    verifyCode=[userDefaults objectForKey:@"verifyCode"];
//    
//    NSMutableDictionary *heads = [[NSMutableDictionary alloc]init];
//    [heads setObject:verifyCode forKey:@"verifyCode"];
//    //话题标题
//    [heads setObject:_txt_title.text forKey:@"title"];
//    //话题内容
//    [heads setObject:_txt_mark.text forKey:@"detail"];
//    //患者姓名
//    [heads setObject:_txt_name.text forKey:@"patientName"];
//    //性别
//    [heads setObject:[NSString stringWithFormat:@"%d",_isSexSelect] forKey:@"sex"];
//    //年龄
//    [heads setObject:_txtAge.text forKey:@"age"];
//    //病情诊断
//    [heads setObject:_txt_diagnose.text forKey:@"illness"];
//    //病状描述
//    [heads setObject:_txt_symptom.text forKey:@"illDetail"];
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
//    [parameters setObject:@"11" forKey:@"11"];
//    [RequestManager postWithURLString:NETCONSULTATIONADDNOIMAGE heads:heads parameters:parameters success:^(id responseObject)
//     {
//         [self.navigationController popViewControllerAnimated:YES];
//         [showAlertView showAlertViewWithMessage:@"添加成功"];
//     } failure:^(NSError *error) {
//         NSLog(@"%@",error);
//     }];
//}

#pragma mark------ 导入病例

-(void)onRightIport{
    
    ImportPatientViewController *imrpo = [[ImportPatientViewController alloc]init];
    imrpo.from= @"webImport";
    [self.navigationController pushViewController:imrpo animated:YES];
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

//
//  sendTalkViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "sendTalkViewController.h"
#import "AddImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface sendTalkViewController ()<UITextViewDelegate,UIScrollViewDelegate,ViewSendImageArrDelegate>
{
    NSMutableArray *imageViewArr;
}
@property (strong, nonatomic) AddImage *viewImage;

//verifyCode身份验证秘钥
@property (strong, nonatomic) NSString *verifyCode;
@property (weak, nonatomic) IBOutlet UILabel *uilabel;

@end

@implementation sendTalkViewController

-(void)viewWillAppear:(BOOL)animated
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userdefault objectForKey:@"verifyCode"];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.title = @"发布话题";
}

#pragma mark - 改变textView时调用
-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""])
    {
        _uilabel.text = @"";
        _uilabel.hidden = YES;
        
        CGRect frame = _opinionText.frame;
        frame.size.height = _opinionText.contentSize.height;
        _opinionText.frame = frame;
        
        CGSize sizeThatShouldFitTheContent = [_opinionText sizeThatFits:_opinionText.frame.size];
        CGFloat a = sizeThatShouldFitTheContent.height - self.textView.frame.size.height;
        
        int i = (int)sizeThatShouldFitTheContent.height;
        if (i>70)
        {
            _heightConstraint2.constant = sizeThatShouldFitTheContent.height;
            self.selfViewHeight.constant = a + self.selfView.frame.size.height;
            [self.opinionText sizeToFit];
        }
    }
    else if ([textView.text isEqualToString:@""])
    {
        _uilabel.text = @"请填写话题内容";
        _uilabel.hidden = NO;
        
        CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(kWith, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        rect.size.width = SCREEN_W;
        rect.size.height = 30;
        _opinionText.frame = rect;
        [_opinionText layoutIfNeeded];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.opinionText.delegate=self;
    self.view.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.selfView.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.053];
    _viewImage=[[AddImage alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.sendImageView.frame.size.height) withViewController:self];
    
    _uiViewHeight.constant = _viewImage.frame.size.height;
    _uiViewHeight.constant= 80+5;
    // 1. 用一个临时变量保存返回值。
    CGRect temp = self.view.frame;
    // 2. 给这个变量赋值。因为变量都是L-Value，可以被赋值
    temp.size.height = 80 +5;
    // 3. 修改frame的值
    _viewImage.frame = temp;
    
    [self.sendImageView addSubview:_viewImage];
    _viewImage.backgroundColor=[UIColor whiteColor];
    self.sendImageView.frame = _viewImage.frame;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendTalk:(UIButton *)sender
{
    //判断标题和内容是否为空
    if ([_titleText.text isEqualToString:@""]||[_opinionText.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithMessage:@"标题和内容不能为空"];
    }
    else if (imageViewArr.count==0)
    {
        [self sendPOSTdata];
    }
    else
    {
        [self sendPOSTdataWihtImage];
    }
}

-(void)sendPOSTdata
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userdefault objectForKey:@"verifyCode"];
    
    //POST 新增患者
    //创建请求管理者
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置头文件
    [manager.requestSerializer setValue:[self.verifyCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]forHTTPHeaderField:@"verifyCode"];
    [manager.requestSerializer setValue:[_titleText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"title"];
    [manager.requestSerializer setValue:[_opinionText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"detail"];
    [manager.requestSerializer setValue:[@"2" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"type"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //创建字典存放数据
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //POST请求
    [manager POST:SENDTOPICRELEASENOPIC parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [self.navigationController popToRootViewControllerAnimated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"分组信息错误 = %@",error);
     }];
}

-(void)sendPOSTdataWihtImage
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userdefault objectForKey:@"verifyCode"];
    //POST 新增患者
    //创建请求管理者
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置头文件
    [manager.requestSerializer setValue:[self.verifyCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]forHTTPHeaderField:@"verifyCode"];
    [manager.requestSerializer setValue:[_titleText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"title"];
    [manager.requestSerializer setValue:[_opinionText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"detail"];
    [manager.requestSerializer setValue:[@"2" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"type"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //创建字典存放数据
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    [manager POST:SENDTOPICRELEASENOPICWITHIMAGE parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        for (int i=0; i<imageViewArr.count; i++)
        {
            ALAsset *asset=imageViewArr[i];
            CGImageRef posterImageRef=[asset aspectRatioThumbnail];
            UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
            UIImage *image = posterImage;
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:imageData name:@"File" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpeg"];
        }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"分组信息成功返回 = %@",responseObject[@"value"]);
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - addimage 添加的方法
-(void)ViewSendImageArr:(NSMutableArray *)imageArr andMaxCount:(NSInteger)maxCount
{
    imageViewArr = imageArr;
    if(imageArr.count<maxCount)
    {
        _uiViewHeight.constant = 80;
    }
    else if ((imageArr.count>=maxCount)&&(imageArr.count<maxCount*2-1))
    {
        _uiViewHeight.constant = 80*2;
    }
    else if(imageArr.count>maxCount*2-1)
    {
        _uiViewHeight.constant = 80*3+3;
    }
}


@end

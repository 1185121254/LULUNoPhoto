//
//  WebViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "WebViewController.h"
#import "eyeValueViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface WebViewController ()<UIWebViewDelegate,viewSendWebViewDelegate,UMSocialUIDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *collectButton;
@property (strong, nonatomic) UIBarButtonItem *shareButton;
//是否收藏 1:收藏  2:未收藏
@property (assign, nonatomic) int isColl;

@end

@implementation WebViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //创建webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    self.webView = webView;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlStr]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    //获取数据
    [self getCollectListData];
}

-(void)getCollectListData
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:userID forKey:@"userId"];
    [self iscollect:NO];
    
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载";
    _HUD.hidden = NO;
    
    
    [RequestManager getWithURLString:GETCOLLECTIONLIST heads:heads parameters:parameters success:^(id responseObject) {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        arr = responseObject[@"value"];
        _HUD.hidden = YES;
        for (NSDictionary *dic in arr)
        {
            int userType = (int)[dic[@"sourceType"] integerValue];
            if (userType==1)//判断是否学术前言
            {
                NSString *title = dic[@"title"];
                if ([title isEqualToString:_CollectTitle])//收藏的标题是否一致
                {
                    _CollectID = dic[@"id"];

                    [self iscollect:YES];
                    ;
                    break;
                }
                else
                {
                    [self iscollect:NO];
                    
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        _HUD.hidden = YES;
        [self iscollect:NO];
    }];
}

-(void)collec
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    if (_isColl==1)//去取消
    {
        [parameters setObject:userID forKey:@"doctorId"];
        //收藏来源ID
        [parameters setObject:_CollectID forKey:@"id"];

        [RequestManager getWithURLString:COLLECTIONREMOVE heads:heads parameters:parameters success:^(id responseObject) {
            [showAlertView showAlertViewWithMessage:@"取消收藏"];
            [self iscollect:NO];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    else if (_isColl==2)//去收藏
    {
        [parameters setObject:userID forKey:@"collector"];
        //收藏来源ID
        [parameters setObject:_CollectID forKey:@"sourceID"];
        [parameters setObject:@"1" forKey:@"sourceType"];
        [parameters setObject:_urlStr forKey:@"webUrl"];
        [parameters setObject:_CollectTitle forKey:@"title"];
        [RequestManager postWithURLString:COLLECTIONADD heads:heads parameters:parameters success:^(id responseObject) {
            [self iscollect:YES];
            [showAlertView showAlertViewWithMessage:@"收藏成功"];
        } failure:^(NSError *error){
            NSLog(@"错误 = %@",error);
        }];
    }
}

#pragma mark - 分享
-(void)share
{
    
    [UMSocialData defaultData].extConfig.title = _CollectTitle;
    
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@",_urlStr];
    
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@",_urlStr];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",_urlStr];
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",_urlStr];

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENGAPPKEY
                                      shareText:[NSString stringWithFormat:@"眼科通 %@:%@",_CollectTitle,_urlStr]
                                     shareImage:[UIImage imageNamed:@"ios-template-180"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

-(void)iscollect:(BOOL)isCollect
{
    if (isCollect==YES)
    {
         _isColl=1;
        //添加收藏按钮
        _collectButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"i-收藏关注_h"] style:UIBarButtonItemStylePlain target:self action:@selector(collec)];
        //分享按钮
        _shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t-share-1"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        NSArray *buttonArray = [[NSArray alloc]initWithObjects:_shareButton,_collectButton,nil];
        self.navigationItem.rightBarButtonItems = buttonArray;
//        NSArray *buttonArray = [[NSArray alloc]initWithObjects:_collectButton,nil];
//        self.navigationItem.rightBarButtonItems = buttonArray;
    }
    else
    {
         _isColl=2;
        //添加收藏按钮
        _collectButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"i-收藏关注"] style:UIBarButtonItemStylePlain target:self action:@selector(collec)];
        //分享按钮
        _shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t-share-1"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        NSArray *buttonArray = [[NSArray alloc]initWithObjects:_shareButton,_collectButton,nil];
//        self.navigationItem.rightBarButtonItems = buttonArray;
//       NSArray *buttonArray = [[NSArray alloc]initWithObjects:_collectButton,nil];
        if (_isCollectisShow==YES)
        {
            self.navigationItem.rightBarButtonItems = buttonArray;
        }
    }
}



-(void)sendImageViewURl:(NSURL *)url
{
    self.urlStr=url;
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

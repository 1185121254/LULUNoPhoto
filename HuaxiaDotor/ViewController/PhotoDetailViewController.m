//
//  PhotoDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/23.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "WebViewJavascriptBridge.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@interface PhotoDetailViewController ()<UIWebViewDelegate>
{
 MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIWebView *webPhotoDetail;
@property WebViewJavascriptBridge* bridge;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [self.webPhotoDetail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

-(void)setNav{

    self.title = @"摄影大赛详情";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(onShare)];
    self.navigationItem.rightBarButtonItem = right;
    
}

#pragma mark----------分享
-(void)onShare{
    [UMSocialData defaultData].extConfig.title = @"眼科通-摄影大赛";
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    //qq控件
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:@"眼科通-摄影大赛" shareImage:[UIImage imageNamed:@"ios-template-180"] shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:nil];
}

#pragma mark---------WebViewDeleaget
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (HUD==nil) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"正在加载";
    }
    HUD.hidden = NO;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    HUD.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    HUD.hidden = YES;
    kAlter(@"网络加载失败");
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

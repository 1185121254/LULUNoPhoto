//
//  PhotographyViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/13.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "PhotographyViewController.h"
#import "PublishPhotoViewController.h"
#import "PhotoPreviewViewController.h"
#import "WebViewJavascriptBridge.h"
#import "PhotoDetailViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@interface PhotographyViewController ()<UIWebViewDelegate>
{
    NSDictionary *photoDicData;
    MBProgressHUD *HUD;
    NSString *url;
}

@property (weak, nonatomic) IBOutlet UIWebView *webViewPhoto;
@property WebViewJavascriptBridge* bridge;

@end

@implementation PhotographyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeCity:) name:@"ChangCityPhoto" object:nil];
    
    [self loadWebViewPhotoProvince:@"" City:@""];

}


#pragma mark------------WebJavaScript

-(void)loadWebViewPhotoProvince:(NSString *)province City:(NSString *)city{

    if ([city isEqualToString:@"全国"]) {
        city = @"";
        province = @"";
    }
    
    url = [NSString stringWithFormat:@"http://www.yanketong.com/Photo/PhotoList.aspx?type=ios&area=%@&city=%@",[province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.webViewPhoto loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
//    [WebViewJavascriptBridge enableLogging];
    
    if (_bridge) {
        return;
    }
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webViewPhoto];
    [_bridge setWebViewDelegate:self];
    //详情
    [_bridge registerHandler:@"DetailPhotography" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PhotoDetailViewController *ph = [[PhotoDetailViewController alloc]init];
        ph.url = [NSString stringWithFormat:@"%@",data];
        ph.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ph animated:YES];
        
    }];
    //新增
    [_bridge registerHandler:@"AddPhotography" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self addPhotography];
        
    }];
    
    //分享
    [_bridge registerHandler:@"SharePhotography" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self shareUM:[NSString stringWithFormat:@"%@",data]];
        
    }];
}

#pragma mark------新增摄影作品
-(void)addPhotography{

    NSDictionary *para = @{@"doctorId":[kUserDefatuel objectForKey:@"id"]};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/GetMyPhotographDetail",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject) {
        photoDicData = (NSDictionary *)responseObject;
        [self isHavePhoto];
    } failure:^(NSError *error) {
        
    }];

}
- (void)isHavePhoto {
    if (photoDicData[@"id"] == nil) {
        PublishPhotoViewController *pub = [[PublishPhotoViewController alloc]init];
        [self.navigationController pushViewController:pub animated:YES];
    }else{
        PhotoPreviewViewController *pre = [[PhotoPreviewViewController alloc]init];
        pre.dicData = photoDicData;
        [self.navigationController pushViewController:pre animated:YES];
    }
}
#pragma mark------选择城市

-(void)onChangeCity:(NSNotification *)notify{

    NSDictionary *dic = notify.object;
    if (dic) {
        [self loadWebViewPhotoProvince:dic[@"province"] City:dic[@"city"]];
    }
}

#pragma mark------WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if ([[NSString stringWithFormat:@"%@",request.URL] isEqualToString:[NSString stringWithFormat:@"%@#",url]]) {
        return NO;
    }else{
        if (HUD==nil) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"正在加载";
        }
        HUD.hidden = NO;
        return YES;
    }
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

}

#pragma mark----------分享
-(void)shareUM:(NSString *)urlShare{
    [UMSocialData defaultData].extConfig.title = @"眼科通-摄影大赛";
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = urlShare;
    //qq控件
    [UMSocialData defaultData].extConfig.qzoneData.url = urlShare;
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlShare;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlShare;
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:@"眼科通-摄影大赛" shareImage:[UIImage imageNamed:@"ios-template-180"] shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:nil];
}


-(void)dealloc{

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

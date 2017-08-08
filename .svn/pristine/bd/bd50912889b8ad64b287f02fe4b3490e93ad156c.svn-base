//
//  AppDelegate.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AppDelegate.h"
#import "AttachmentDecoder.h"
#import "iflyMSC/IFlyMSC.h"
#import "HomeViewController.h"
#import "UMMobClick/MobClick.h"
#import "GuideViewController.h"
#import "IQKeyboardManager.h"
//#import "LoginViewController.h"
#import "NTESVideoChatViewController.h"

//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsPlatformManager.h"
//友盟推送
#import "UMessage.h"
//图文咨询
#import "ConsultingViewController.h"
//电话咨询
#import "PhoneViewController.h"
//视频咨询
#import "VideoTableViewController.h"
//互联网会诊
#import "WebLineInfoVIew.h"
//加号网会诊
#import "AddManagerViewController.h"
#import "HomeView.h"
#import "HomeToolController.h"
@interface AppDelegate ()<NIMSystemNotificationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    self.window.backgroundColor = [UIColor whiteColor];
#pragma mark---------友盟推送
    
    [UMessage startWithAppkey:@"577c5c2fe0f55a6e1e004439" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
#pragma mark---------网易云信推送/注册
    [[NIMSDK sharedSDK] registerWithAppID:@"38d14c2a5f20cd1a9c681a32a738fe00"
                                  cerName:@"DocDistru"];
    [self registerAPNs];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[[NIMSDK sharedSDK] apnsManager] registerBadgeCountHandler:^NSUInteger{
        return 0;
    }];
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
#pragma mark---------注册自定义消息
    [NIMCustomObject registerCustomDecoder:[[AttachmentDecoder alloc]init]];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
#pragma mark---------友盟统计
    UMConfigInstance.appKey = @"577c5c2fe0f55a6e1e004439";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
#pragma mark---------分享
    [self share];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //电池和导航栏的颜色
    [[UINavigationBar appearance] setBarTintColor:BLUECOLOR_STYLE];
    
#pragma mark---------讯飞
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@" 5730536a"];
    [IFlySpeechUtility createUtility:initString];
    
#pragma mark---------引导页
    if ([self isFirstLaunch]) {
        GuideViewController *gud = [[GuideViewController alloc]init];
        self.window.rootViewController = gud;
    }else
    {
        [self goHome];
    }
    return YES;
}


- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    return 0;
}

#pragma mark---------推送
- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

#pragma mark-----------注册推送

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    [UMessage registerDeviceToken:deviceToken];
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark---------系统推送
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSString *str = [notification.content stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([dic objectForKey:@"type"]) {
        
        NSArray *array = self.window.rootViewController.navigationController.viewControllers;
        
        if ([array.lastObject isKindOfClass:[LoginViewController class]]) {
            return;
        }
        
        if ([[NIMSDK sharedSDK].loginManager isLogined] == NO) {
            return;
        }
        [self reciveNotifyRefreshViewController];

        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"content"] preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alter addAction:[UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self goOtherViewController:dic];
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
    }
}

-(void)goOtherViewController:(NSDictionary *)dic{

    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    switch ([[dic objectForKey:@"type"] integerValue]) {
        case 11:
        {
            //图文咨询
            UIStoryboard *consultingStory=[UIStoryboard storyboardWithName:@"Consulting" bundle:[NSBundle mainBundle]];
            ConsultingViewController *consulting = [consultingStory instantiateViewControllerWithIdentifier:@"consultingView"];
            if ([nav.viewControllers.lastObject isKindOfClass:[consulting class]]) {
                
                ConsultingViewController *consultingCurren = nav.viewControllers.lastObject;
                [consultingCurren reciveNotifyToRefreshConsult];
                
                return;
            }
            [nav pushViewController:consulting animated:YES];
        }
            break;
        case 22:
        {
            //电话咨询
            PhoneViewController *phine = [[PhoneViewController alloc]init];
            if ([nav.viewControllers.lastObject isKindOfClass:[phine class]]) {
                
                PhoneViewController *PhoneCurren = nav.viewControllers.lastObject;
                [PhoneCurren recivrNotifyRefreshPhone];
                
                return;
            }
            [nav pushViewController:phine animated:YES];
        }
            break;
        case 33:
        {
            //视频咨询
            VideoTableViewController *viedo = [[VideoTableViewController alloc]init];
            if ([nav.viewControllers.lastObject isKindOfClass:[viedo class]]) {
                
                VideoTableViewController *viedoCurren = nav.viewControllers.lastObject;                
                [viedoCurren reciveNotifyToRefresh];
                return;
            }
            viedo.xtrID = @"";
            [nav pushViewController:viedo animated:YES];
        }
            break;
        case 44:
        {
            //加号咨询
            UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"AddManager" bundle:[NSBundle mainBundle]];
            AddManagerViewController *webView=[storyboardName instantiateViewControllerWithIdentifier:@"AddManagerView"];
            if ([nav.viewControllers.lastObject isKindOfClass:[webView class]]) {
                return;
            }
            [nav pushViewController:webView animated:YES];
        }
            break;
        case 55:
        {
            //互联网会诊
            UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
            WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
            webView.str_topID = [dic objectForKey:@"id"];
            webView.isCircle = NO;
            if ([nav.viewControllers.lastObject isKindOfClass:[webView class]]) {
                WebLineInfoVIew *webInfo = nav.viewControllers.lastObject;
                [webInfo.navigationController pushViewController:webView animated:YES];
            }
            else
            {
                [nav pushViewController:webView animated:YES];
            }
        }
            break;
        case 66:
        {
            //眼科圈
            UIStoryboard *consultingStory=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
            WebLineInfoVIew *eyes = [consultingStory instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
            eyes.str_topID = [dic objectForKey:@"id"];
            eyes.isCircle = YES;
            if ([nav.viewControllers.lastObject isKindOfClass:[eyes class]]) {
                WebLineInfoVIew *webInfo = nav.viewControllers.lastObject;
                [webInfo.navigationController pushViewController:eyes animated:YES];
            }
            else
            {
                [nav pushViewController:eyes animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 分享
-(void)share
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENGAPPKEY];
    [UMSocialWechatHandler setWXAppId:@"wx5afc3dd50f3008ac" appSecret:@"da4010181ad87ee1bc8888aee2d98d40" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105438551" appKey:@"262wPG3aabcYjOn2" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //隐藏没有安装的app
    //    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
}

#pragma mark - 从其他软件跳转到当前应用,调用此方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE)
    {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark---------是否是第一次登录
-(BOOL)isFirstLaunch{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)reciveNotifyRefreshViewController{

    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    NSArray *arry = nav.viewControllers;
    
    if ([arry.lastObject isKindOfClass:[HomeViewController class]]) {
        
        HomeViewController *home = (HomeViewController *)arry.lastObject;
        HomeView *homeV = home.childViewControllers.firstObject;
        HomeToolController *tool = homeV.childViewControllers.firstObject;
        [tool unreadMsgCount];
    }
}

#pragma mark---------进入首页
-(void)goHome{
    UIStoryboard *HomeView=[UIStoryboard storyboardWithName:@"HomeView" bundle:[NSBundle mainBundle]];
    HomeViewController *HomeViewController=[HomeView instantiateViewControllerWithIdentifier:@"HomeView"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:HomeViewController];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearance]
     setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController = nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[[NIMSDK sharedSDK] apnsManager] registerBadgeCountHandler:^NSUInteger{
        return 0;
    }];
    
    if (application.applicationState!=UIApplicationStateActive) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:userInfo];
    }
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
}



@end

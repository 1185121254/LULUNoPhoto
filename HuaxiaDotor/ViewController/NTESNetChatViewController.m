//
//  NTESNetChatViewController.m
//  NIM
//
//  Created by chris on 15/5/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNetChatViewController.h"
#import "NTESTimerHolder.h"
#import "NetCallChatInfo.h"
#import "NTESBundleSetting.h"
#import "NTESGlobalMacro.h"
#import "UIAlertView+NTESBlock.h"
#import "ChatViedoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
#define DelaySelfStartControlTime 10
//激活铃声后无人接听的超时时间
#define NoBodyResponseTimeOut 40

//周期性检查剩余磁盘空间
#define DiskCheckTimeInterval 10
//剩余磁盘空间不足的警告阈值
#define MB (1024ll * 1024ll)
#define FreeDiskSpaceWarningThreshold (10 * MB)

@interface NTESNetChatViewController ()

@property (nonatomic, strong) NTESTimerHolder *timer;

@property (nonatomic, strong) NSMutableArray *chatRoom;

@property (nonatomic, assign) BOOL recordWillStopForLackSpace;

@property (nonatomic, strong) NTESTimerHolder *diskCheckTimer;

@property (nonatomic, assign) BOOL userHangup;

@property (nonatomic, strong) NTESTimerHolder *calleeResponseTimer; //被叫等待用户响应接听或者拒绝的时间
@property (nonatomic, assign) BOOL calleeResponsed;

@property(nonatomic,assign) BOOL isConnect;
@end

@implementation NTESNetChatViewController

NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithCallee:(NSString *)callee{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.callInfo.callee = callee;
        self.callInfo.caller = [[NIMSDK sharedSDK].loginManager currentAccount];
    }
    return self;
}

- (instancetype)initWithCaller:(NSString *)caller callId:(uint64_t)callID{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.callInfo.caller = caller;
        self.callInfo.callee = [[NIMSDK sharedSDK].loginManager currentAccount];
        self.callInfo.callID = callID;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        if (!self.callInfo) {
            [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
            _callInfo = [[NetCallChatInfo alloc] init];
        }
        _timer = [[NTESTimerHolder alloc] init];
        _diskCheckTimer = [[NTESTimerHolder alloc] init];
        //防止应用在后台状态，此时呼入，会走init但是不会走viewDidLoad,此时呼叫方挂断，导致被叫监听不到，界面无法消去的问题。
        id<NIMNetCallManager> manager = [NIMSDK sharedSDK].netCallManager;
        [manager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    [self checkServiceEnable:^(BOOL result) {
        if (result) {
            [wself afterCheckService];
        }else{
            //用户禁用服务，干掉界面
            if (wself.callInfo.callID) {
                //说明是被叫方
                [[NIMSDK sharedSDK].netCallManager response:wself.callInfo.callID accept:NO option:nil completion:nil];
            }
            [wself dismiss:nil];
        }
    }];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)afterCheckService{
    if (self.callInfo.isStart) {
        [self.timer startTimer:0.5 delegate:self repeats:YES];
        [self onCalling];
    }
    else if (self.callInfo.callID) {
        [self startByCallee];
    }
    else {
        [self startByCaller];
    }
    
    [self checkFreeDiskSpace];
    [self.diskCheckTimer startTimer:DiskCheckTimeInterval
                           delegate:self
                            repeats:YES];
}

#pragma mark - Subclass Impl
- (void)startByCaller{
    _isConnect = NO;
    [self playConnnetRing];
    __weak typeof(self) wself = self;
    //等铃声播完再打过去，太快的话很假
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) {
            return;
        }
        if (wself.userHangup) {
            return;
        }
        wself.callInfo.isStart = YES;
        NSArray *callees = [NSArray arrayWithObjects:wself.callInfo.callee, nil];
        
        NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
        option.extendMessage = self.callInfo.orderID;

        option.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
        option.apnsContent = [NSString stringWithFormat:@"%@请求", wself.callInfo.callType == NIMNetCallTypeAudio ? @"网络通话" : @"视频聊天"];
        option.apnsSound = @"video_chat_tip_receiver.aac";
        option.serverRecordVideo = YES;
        
        [[NIMSDK sharedSDK].netCallManager start:callees type:wself.callInfo.callType option:option completion:^(NSError *error, UInt64 callID) {
            if (!error && wself) {
                wself.callInfo.callID = callID;
                wself.chatRoom = [[NSMutableArray alloc]init];
                //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
                NSTimeInterval delayTime = DelaySelfStartControlTime;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself onControl:callID from:wself.callInfo.callee type:NIMNetCallControlTypeFeedabck];
                });
            }else{
                if (error) {

                }else{
                    //说明在start的过程中把页面关了。。
                    [[NIMSDK sharedSDK].netCallManager hangup:callID];
                }
                [wself dismiss:nil];
            }
        }];
    });
}

- (void)startByCallee{
    //告诉对方可以播放铃声了
    self.callInfo.isStart = YES;
    NSMutableArray *room = [[NSMutableArray alloc] init];
    [room addObject:self.callInfo.caller];
    self.chatRoom = room;
    [[NIMSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeFeedabck];
    [self playReceiverRing];
    _calleeResponseTimer = [[NTESTimerHolder alloc] init];
    [_calleeResponseTimer startTimer:NoBodyResponseTimeOut delegate:self repeats:NO];
}


- (void)hangup{
    _userHangup = YES;
    [[NIMSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    
    if (self.callInfo.localRecording) {
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wself.chatRoom = nil;
            [wself dismiss:nil];
        });
    }
    else {
        self.chatRoom = nil;
        [self dismiss:nil];
    }
    
}

- (void)response:(BOOL)accept{
    
    _calleeResponsed = YES;
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
    option.serverRecordAudio = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo = [[NTESBundleSetting sharedConfig] serverRecordVideo];

    __weak typeof(self) wself = self;

    [[NIMSDK sharedSDK].netCallManager response:wself.callInfo.callID accept:accept option:option completion:^(NSError *error, UInt64 callID) {
        if (!error) {
                [wself onCalling];
                [wself.player stop];
                [wself.chatRoom addObject:wself.callInfo.callee];
                NSTimeInterval delay = 10.f; //10秒后判断下房间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (wself.chatRoom.count == 1) {

                        [wself hangup];
                    }
                });
        }else{
            wself.chatRoom = nil;

            [wself dismiss:nil];
        }
    }];
    //dismiss需要放在self后面，否在ios7下会有野指针
    if (accept) {
        [wself waitForConnectiong];
    }else{
        [wself dismiss:nil];
    }
}

- (void)dismiss:(void (^)(void))completion{
    //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype  = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    [self setUpStatusBar:UIStatusBarStyleDefault];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }

    //是否来自与免费咨询
    if (![self.callInfo.from isEqualToString:@"free"]) {
        [self changState];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//修改支付状态
-(void)changState{
    if (_isConnect == YES) {
        
        //服务器传订单
        NSString *strt =[NSString stringWithFormat:@"%llu",self.callInfo.callID];
        NSDictionary *para = @{@"orderId":self.callInfo.orderID,@"channelId":strt};
        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/ExtendApi/VideoChannelAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self  success:^(id responseObject, BOOL ifTimeout) {
            
        } failure:^(NSError *error) {
            
        }];
        
        //修改支付状态
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.callInfo.orderID forKey:@"orderId"];
        [dic setObject:@"4" forKey:@"state"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/TextOrdeTypeUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self   success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        NSLog(@"未接听 %@",self.callInfo.orderID);
    }
}


- (void)onCalling{
    //子类重写
    _isConnect = YES;
    

    
    
}

- (void)waitForConnectiong{
    //子类重写
}


//- (BOOL)startLocalRecording
//{
//    NSString *fileName = [NSString stringWithFormat:@"videochat_record_%llu.mp4", self.callInfo.callID];
//    NSURL *filePath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:fileName];
//    
//    BOOL startAccepted;
//    startAccepted = [[NIMSDK sharedSDK].netCallManager startLocalRecording:filePath
//                                                              videoBitrate:0];
//    return startAccepted;
//}
//
//
//- (BOOL)stopLocalRecording
//{
//    return [[NIMSDK sharedSDK].netCallManager stopLocalRecording];
//}

- (void)udpateLowSpaceWarning:(BOOL)show
{
    //子类重写
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control;{
    switch (control) {
        case NIMNetCallControlTypeFeedabck:{
            NSMutableArray *room = self.chatRoom;
            if (room && !room.count) {
                [self playSenderRing];
                [room addObject:self.callInfo.caller];
                //40秒之后查看一下房间状态，如果房间还在一个人的话，就播放铃声超时
                __weak typeof(self) wself = self;
                uint64_t callId = self.callInfo.callID;
                NSTimeInterval delayTime = NoBodyResponseTimeOut;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSMutableArray *room = wself.chatRoom;
                    if (wself && room && room.count == 1) {
                        [[NIMSDK sharedSDK].netCallManager hangup:callId];
                        wself.chatRoom = nil;
                        [wself playTimeoutRing];
                        [wself dismiss:nil];
                    }
                });
            }
            break;
        }
        case NIMNetCallControlTypeBusyLine: {
            [self playOnCallRing];
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });
            break;
        }
        case NIMNetCallControlTypeStartLocalRecord:
            break;
        case NIMNetCallControlTypeStopLocalRecord:
            break;
        default:
            break;
    }
}

- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted{
    if (self.callInfo.callID == callID) {
        if (!accepted) {
            self.chatRoom = nil;
            [self playHangUpRing];
            [self dismiss:nil];
        }else{
            [self.player stop];
            [self onCalling];
            [self.chatRoom addObject:callee];
        }
    }
}

- (void)onCall:(UInt64)callID status:(NIMNetCallStatus)status{
    if (self.callInfo.callID != callID) {
        return;
    }
    //记时
    switch (status) {
        case NIMNetCallStatusConnect:
            //开始计时
            self.callInfo.startTime = [NSDate date].timeIntervalSince1970;
//            [self.timer startTimer:0.5 delegate:self repeats:YES];
            break;
        case NIMNetCallStatusDisconnect:
            //结束计时
            [self.timer stopTimer];
            [self dismiss:nil];
            self.chatRoom = nil;
            break;
        default:
            break;
    }
}

- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted{
    [self dismiss:nil];
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user{
    if (self.callInfo.callID == callID) {
        if (self.callInfo.localRecording) {
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });
        }
        else {
            [self dismiss:nil];
        }
    }
}


#pragma mark - M80TimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
    if (holder == self.diskCheckTimer) {
        [self checkFreeDiskSpace];
    }
    else if(holder == self.calleeResponseTimer) {
        if (!_calleeResponsed) {
            [self response:NO];
        }
    }
}


#pragma mark - Misc
- (void)checkServiceEnable:(void(^)(BOOL))result{
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async_main_safe(^{
                if (granted) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"相机权限受限,无法视频聊天"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                            if (result) {
                                result(NO);
                            }
                        }];
                    }else{
                        if (result) {
                            result(YES);
                        }
                    }
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"麦克风权限受限,无法聊天"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                        if (result) {
                            result(NO);
                        }
                    }];
                }

            });
        }];
    }
}

- (void)setUpStatusBar:(UIStatusBarStyle)style{
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}


- (void)checkFreeDiskSpace{
    if (self.callInfo.localRecording) {
        uint64_t freeSpace = 1000 * MB;
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSDictionary *attrbites = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
        
        if (attrbites) {
            NSNumber *freeFileSystemSizeInBytes = [attrbites objectForKey:NSFileSystemFreeSize];
            freeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        
            [self udpateLowSpaceWarning:(freeSpace < FreeDiskSpaceWarningThreshold)];
        }
    }
}

#pragma mark - Ring
//铃声 - 正在呼叫请稍后
- (void)playConnnetRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_connect_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方暂时无法接听
- (void)playHangUpRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_HangUp" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方正在通话中
- (void)playOnCallRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_OnCall" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方无人接听
- (void)playTimeoutRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_onTimer" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 接收方铃声
- (void)playReceiverRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}

//铃声 - 拨打方铃声
- (void)playSenderRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}



@end

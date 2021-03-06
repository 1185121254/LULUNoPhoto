//
//  ShareAppViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/9/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ShareAppViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface ShareAppViewController ()

@end

@implementation ShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"分享APP";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    
    NSDictionary *dic  = @{@"type":@"1"};
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetInviteCode",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        
        NSDictionary *dicValue = (NSDictionary *)responseObject;
        
        if (dicValue[@"id"]) {
            _intiveCode.text = [NSString stringWithFormat:@"邀请码：%@",dicValue[@"id"]];
        }
            
        if (dicValue[@"allUrl"]) {
            _QRCode.contentMode = UIViewContentModeScaleAspectFit;
            [_QRCode sd_setImageWithURL:[NSURL URLWithString:dicValue[@"allUrl"]] placeholderImage:[UIImage imageNamed:@"感叹号"]];
        }
        

    } failure:^(NSError *error) {

    }];

}

- (IBAction)share:(id)sender {
    NSDictionary *dic = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    
    [UMSocialData defaultData].extConfig.title = @"眼科通-下载";
    
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://www.yanketong.com/H5/InviteCode-doctor.aspx?id=%@&type=1",dic[@"id"]];
    
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://www.yanketong.com/H5/InviteCode-doctor.aspx?id=%@&type=1",dic[@"id"]];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.yanketong.com/H5/InviteCode-doctor.aspx?id=%@&type=1",dic[@"id"]];
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.yanketong.com/H5/InviteCode-doctor.aspx?id=%@&type=1",dic[@"id"]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:@"眼科通 一站式、安全、便捷、实惠、7 x 12小时在线、贴心、优质、经济..." shareImage:[UIImage imageNamed:@"ios-template-180"] shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:nil];
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

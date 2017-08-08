//
//  HomeToolController.h
//  dawnEye
//
//  Created by KockPeter on 16/3/8.
//  Copyright © 2016年 kockPeter. All rights reserved.
//  首页常用工具栏控制器

#import <UIKit/UIKit.h>
#import "AdView.h"

@interface HomeToolController : UITableViewController
{
    AdView * adView;
    MBProgressHUD *_HUD;
    //数组轮播图
    NSMutableArray *_arryImageURL;
    BOOL _isNetNomal;

}

//广告试图容器
@property (weak, nonatomic) UIView *adview;

//滚动试图
@property (weak, nonatomic) IBOutlet UIView *adViewCell;
//图文咨询未读消息数
@property (weak, nonatomic) IBOutlet UILabel *UnReadMsg;
@property (weak, nonatomic) IBOutlet UILabel *patientReportUnReadMs;
@property (weak, nonatomic) IBOutlet UILabel *caseConUnReadMsg;
@property (weak, nonatomic) IBOutlet UILabel *freeUnReadMsg;
@property (weak, nonatomic) IBOutlet UILabel *addressUnReadMsg;
@property (weak, nonatomic) IBOutlet UILabel *phoneUnRead;
@property (weak, nonatomic) IBOutlet UILabel *viedoUnread;

@property (strong, nonatomic) IBOutlet UITableView *tableHome;


-(void)unreadMsgCount;


@end

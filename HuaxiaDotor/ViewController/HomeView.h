//
//  HomeView.h
//  dawnEye
//
//  Created by KockPeter on 16/3/8.
//  Copyright © 2016年 kockPeter. All rights reserved.
//  首页的视图控制器

#import <UIKit/UIKit.h>

@interface HomeView : UIViewController

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//医生姓名
@property (weak, nonatomic) IBOutlet UILabel *doctorName;


//患者总量
@property (weak, nonatomic) IBOutlet UILabel *Totol;
//今日总量
@property (weak, nonatomic) IBOutlet UILabel *todayTotol;

@property (weak, nonatomic) IBOutlet UILabel *lblCertification;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCertification;


@property (weak, nonatomic) IBOutlet UILabel *readNum;

@end

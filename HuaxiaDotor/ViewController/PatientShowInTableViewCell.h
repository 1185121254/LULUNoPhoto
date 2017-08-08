//
//  PatientShowInTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/6/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientShowInTableViewCell : UITableViewCell

//医生头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//医生名字
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
//医生级别
@property (weak, nonatomic) IBOutlet UILabel *doctorGread;
//医院
@property (weak, nonatomic) IBOutlet UILabel *hospital;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
//名字
@property (weak, nonatomic) IBOutlet UILabel *caseTitle;
//内容
@property (weak, nonatomic) IBOutlet UILabel *caseInfo;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel *lblStart;
//回复个数
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
//收藏个数
@property (weak, nonatomic) IBOutlet UILabel *lblCollect;
//图片张数
@property (weak, nonatomic) IBOutlet UILabel *imageQuickCount;
//图片预览
@property (weak, nonatomic) IBOutlet UIImageView *viewForQuickImage;
//试图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForImageView;
//个数小图
@property (weak, nonatomic) IBOutlet UIView *viewForShowCount;

-(void)setCell:(NSMutableDictionary *)dic;

@end

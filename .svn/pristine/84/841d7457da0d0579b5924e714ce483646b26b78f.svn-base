//
//  FriendvalidationTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/6.
//  Copyright © 2016年 kock. All rights reserved.
//  好友验证列表

#import <UIKit/UIKit.h>

@protocol relodataTableView <NSObject>

-(void)reloadTableViewWithData:(NSDictionary *)data;

@end

@interface FriendvalidationTableViewCell : UITableViewCell

@property (strong, nonatomic) id <relodataTableView>reloadDelegate;

@property (strong, nonatomic) NSString *verifyCode,*userID;


//同意提示
@property (weak, nonatomic) IBOutlet UILabel *lbl_agree;
//职称
@property (weak, nonatomic) IBOutlet UILabel *lbl_Subtitles;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
//科室
@property (weak, nonatomic) IBOutlet UILabel *lbl_department;
//医院
@property (weak, nonatomic) IBOutlet UILabel *lbl_hospital;
//不同意
@property (weak, nonatomic) IBOutlet UIButton *btn_unAgree;
//同意
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
//关联ID
@property (strong, nonatomic) NSString *str_aboutID;
//是否同意
-(void)setCell:(NSDictionary *)dic;
//申请者ID
@property (strong, nonatomic) NSString *str_applyId;

@end

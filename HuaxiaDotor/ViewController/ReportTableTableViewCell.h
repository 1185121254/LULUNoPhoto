//
//  ReportTableTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imageAvater;
@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UILabel *lblIllness;
@property(nonatomic,strong)UILabel *lblTime;
@property(nonatomic,strong)UILabel *lblLastTime;
@property(nonatomic,strong)UIButton *btnState;
@property(nonatomic,strong)UILabel *lblNewMeg;

-(void)setPatientData:(NSDictionary *)dic state:(NSString *)state;

@end

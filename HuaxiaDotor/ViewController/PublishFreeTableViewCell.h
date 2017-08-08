//
//  PublishFreeTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishFreeTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *lblTitle;
@property(nonatomic,strong)UILabel *lblDate;
@property(nonatomic,strong)UILabel *lblCount;
@property(nonatomic,strong)UILabel *lblDatePicker;
@property(nonatomic,strong)UILabel *lblCountPicker;
@property(nonatomic,strong)UIButton *btnDatePicker;
@property(nonatomic,strong)UIButton *btnCountPicker;
@property(nonatomic,strong)UIButton *btnDelete;

@end

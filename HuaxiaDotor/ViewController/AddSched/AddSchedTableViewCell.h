//
//  AddSchedTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSchedTableViewCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *lblTime;
@property(nonatomic,strong)UILabel *lblCount;
@property(nonatomic,strong)UIButton *btnTime;
@property(nonatomic,strong)UIButton *btnCount;
@property(nonatomic,strong)UIButton *btnReduce;

@end

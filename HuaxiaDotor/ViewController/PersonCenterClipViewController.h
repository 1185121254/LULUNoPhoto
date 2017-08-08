//
//  PersonCenterClipViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailModel.h"

@interface PersonCenterClipViewController : BaseViewController

@property(nonatomic,strong)GroupDetailModel *group;
@property(nonatomic,copy)NSString *from;

@end

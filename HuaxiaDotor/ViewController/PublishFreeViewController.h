//
//  PublishFreeViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HillFreeModel.h"

@interface PublishFreeViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *arryBeenPub;
@property(nonatomic,strong)HillFreeModel *hillModel;
@property(nonatomic,copy)NSString *from;


@end

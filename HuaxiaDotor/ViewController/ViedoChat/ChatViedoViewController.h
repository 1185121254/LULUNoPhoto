//
//  ChatViedoViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViedoViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray *arryViedo;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,strong)UITableView *tableVIew;
@property(nonatomic,copy)NSString *from;

@end

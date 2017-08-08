//
//  VideoTableViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewController : UIViewController

@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *xtrID;

-(void)reciveNotifyToRefresh;

@end

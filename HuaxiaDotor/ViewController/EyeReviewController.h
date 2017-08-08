//
//  EyeReviewTableViewController.h
//  HuaxiaDotor
//
//  Created by kock on 16/4/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSendArrDataDelegate <NSObject>

-(void)sendImageViewArr:(NSMutableArray*)picArr;

@end

@interface EyeReviewController : UIViewController

@property (strong, nonatomic) id <ViewSendArrDataDelegate> delegate;

@end

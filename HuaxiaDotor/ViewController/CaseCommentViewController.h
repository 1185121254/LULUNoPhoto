//
//  CaseCommentViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseModel.h"
@interface CaseCommentViewController : UIViewController

@property(nonatomic,strong)CaseModel *model;
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSDictionary *dicGroup;

-(void)sendDoctorMessage:(NSString *)mes;

@end

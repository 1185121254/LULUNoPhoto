//
//  DocAddViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocAdviceDetailModel.h"

@interface DocAddViewController : UIViewController

@property(nonatomic,strong)DocAdviceDetailModel *docDeatilModel;
@property(nonatomic,strong)NSString *hispaicalNum;
@property(nonatomic,copy)NSString *from;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,copy)NSString *name;

@end

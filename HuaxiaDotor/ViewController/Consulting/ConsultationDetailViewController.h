//
//  ConsultationDetailViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultationDetailViewController : UIViewController

@property(nonatomic,strong)PatientModel *patient;
@property(nonatomic,copy)NSString *from;

@end

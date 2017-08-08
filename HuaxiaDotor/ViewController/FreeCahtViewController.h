//
//  FreeCahtViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientModel.h"

@interface FreeCahtViewController : UIViewController

@property(nonatomic,strong)NSDictionary *patientDoc;
@property(nonatomic,strong)NSArray *arryDep;
@property(nonatomic,strong)PatientModel *patientModel;
@property(nonatomic,copy)NSString *state;


@end

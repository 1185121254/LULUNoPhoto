//
//  NewCaseScrollViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/8/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCaseScrollViewController : UIViewController

//传来的值
@property(nonatomic,strong)PatientDetailModel *model;

//scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrolVIewNew;
//患者
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientHeigth;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UILabel *patientAge;
//疾病诊断
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diagnoseHeight;
@property (weak, nonatomic) IBOutlet UITextView *diagnoseTextView;
@property (weak, nonatomic) IBOutlet UILabel *diagnosePlacor;
//症状描述
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *despHeight;
@property (weak, nonatomic) IBOutlet UITextView *despTextView;
@property (weak, nonatomic) IBOutlet UILabel *despPlacor;
//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (weak, nonatomic) IBOutlet UIView *picView;
//检查项目
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkHeight;
@property (weak, nonatomic) IBOutlet UITextView *checkTextView;
@property (weak, nonatomic) IBOutlet UILabel *checkPlacor;
//用药记录
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drugHeight;
@property (weak, nonatomic) IBOutlet UILabel *drugPlacor;
@property (weak, nonatomic) IBOutlet UITextView *drugTextView;





@end

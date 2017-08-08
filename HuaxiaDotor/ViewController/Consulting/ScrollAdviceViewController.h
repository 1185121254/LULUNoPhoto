//
//  ScrollAdviceViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/8/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollAdviceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollAdvice;

//传来值
@property(nonatomic,strong)PatientModel *patient;
@property(nonatomic,copy)NSString *from;
//症状描述
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *despHeight;
@property (weak, nonatomic) IBOutlet UITextView *despTextView;

//资料图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (weak, nonatomic) IBOutlet UIView *picView;

//初步预诊
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reslutHeight;
@property (weak, nonatomic) IBOutlet UITextView *reslutTextView;
@property (weak, nonatomic) IBOutlet UILabel *resultPlacor;
@property (weak, nonatomic) IBOutlet UIButton *resultBtn;

//建议用药
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drugHeight;
@property (weak, nonatomic) IBOutlet UITextView *drugTextView;
@property (weak, nonatomic) IBOutlet UILabel *drugPlacor;
@property (weak, nonatomic) IBOutlet UIButton *drugBtn;

//建议检查项目
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkHeight;
@property (weak, nonatomic) IBOutlet UITextView *checkTextView;
@property (weak, nonatomic) IBOutlet UILabel *checkPlacor;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

//诊断建议
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviceHeight;
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UILabel *advicePlacor;
@property (weak, nonatomic) IBOutlet UIButton *adviceBtn;

//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSummitHeight;


@end

//
//  SendCaseViewController.h
//  HuaxiaDotor
//
//  Created by kock on 16/4/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCaseViewController : UIViewController

//病例标题
@property (weak, nonatomic) IBOutlet UITextField *titleText;

//看法
@property (weak, nonatomic) IBOutlet UITextView *opinionText;
//照片的view
@property (weak, nonatomic) IBOutlet UIView *imaView;
//导入病例按钮
@property (weak, nonatomic) IBOutlet UIButton *guideCaseButton;
//文本View
@property (weak, nonatomic) IBOutlet UIView *textView;

//textView高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withFortextView;
//滚动试图
@property (weak, nonatomic) IBOutlet UIScrollView *SendscrollerView;

//图片的试图
@property (weak, nonatomic) IBOutlet UIView *sendImageView;
//图片试图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uiViewHeight;

//本视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfViewHeight;
//本视图
@property (weak, nonatomic) IBOutlet UIView *selfView;


@end

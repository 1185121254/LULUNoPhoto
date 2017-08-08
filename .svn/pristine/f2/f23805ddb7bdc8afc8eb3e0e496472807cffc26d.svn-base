//
//  BaseDatePickerViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "BaseDatePickerViewController.h"
#import "AddPatientTableViewController.h"

@interface BaseDatePickerViewController ()

{
    UIDatePicker *_datePicker;
    UIView *ViewB;
}

@end

@implementation BaseDatePickerViewController

-(id)initWithModel:(NSInteger)mode{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.2];
        self.frame = CGRectMake(0, 0, kWith, kHeight);
        self.hidden = YES;
        
        if (ViewB == nil) {
            ViewB = [[UIView alloc]init];
        }
        ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
        ViewB.backgroundColor = kBackgroundColor;
        [self addSubview:ViewB];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        btnCancel.frame = CGRectMake(0, 0, 80, 40);
        [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:18];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(onCancelDoc) forControlEvents:UIControlEventTouchUpInside];
        [ViewB addSubview:btnCancel];
        
        UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeSystem];
        btnSure.frame = CGRectMake(kWith-80, 0, 80, 40);
        [btnSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnSure.titleLabel.font = [UIFont systemFontOfSize:18];
        [btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [btnSure addTarget:self action:@selector(onSureDoc) forControlEvents:UIControlEventTouchUpInside];
        [ViewB addSubview:btnSure];
        
        if (_datePicker== nil) {
            _datePicker  = [[UIDatePicker alloc]init];
        }
        [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.frame= CGRectMake(0, 40, kWith, 200);

        if (mode == 0) {
            _datePicker.datePickerMode = UIDatePickerModeTime;
        }else if(mode == 1){
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }else if(mode == 2){
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }else if(mode == 3){
            _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }
        [ViewB addSubview:_datePicker];
    }
    return self;
}

-(void)datePickerShow:(NSDate *)maxDate MinDate:(NSDate *)minDate{
    self.hidden = NO;
    if (maxDate) {
        _datePicker.maximumDate = maxDate;
    }
    if (minDate) {
        _datePicker.minimumDate = minDate;
    }
    [UIView beginAnimations:nil context:nil];
    if ([[self viewController] isKindOfClass:[AddPatientTableViewController class] ]) {
        ViewB.frame = CGRectMake(0, kHeight-240-64, kWith, 240);

    }else
    {
        ViewB.frame = CGRectMake(0, kHeight-240, kWith, 240);

    }
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
}

-(void)dateSetDate:(NSDate *)date
{
    if (date) {
        [_datePicker setDate:date];
    }
}

-(void)onCancelDoc{
    [UIView beginAnimations:@"remove" context:nil];
    ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)onSureDoc{

    [self.delegate setDateFromDatePicker:_datePicker.date];
    [UIView beginAnimations:@"remove" context:nil];

    ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    if (CGRectContainsPoint(CGRectMake(0, 0, kWith, kHeight-230),point)) {
        [UIView beginAnimations:@"remove" context:nil];
        ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{

    if ([animationID isEqualToString:@"remove"]) {
        self.hidden = YES;
    }
    
}
//找到Viewb的视图控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

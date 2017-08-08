//
//  BaseDatePickerViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/7/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseDatePickerDelegate <NSObject>

-(void)setDateFromDatePicker:(NSDate *)date;

@end

@interface BaseDatePickerViewController : UIView

@property(nonatomic,assign)id <BaseDatePickerDelegate>delegate;

-(id)initWithModel:(NSInteger)mode;
-(void)datePickerShow:(NSDate *)maxDate MinDate:(NSDate *)minDate;
//默认选择的时间
-(void)dateSetDate:(NSDate*)date;

@end

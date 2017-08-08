//
//  BasePickerView.h
//  HuaxiaDotor
//
//  Created by ydz on 16/7/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BasePickerViewDelegate <NSObject>

-(void)setPicker:(NSString *)count;

@end
@interface BasePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *_picker;
    UIView *ViewB;
    UILabel *_lblSelected;
    NSArray *_arrydate;
    
    NSString *_hour;
    NSString *_min;

}

@property(nonatomic,assign)id <BasePickerViewDelegate>delegate;

-(void)pickerDelegateShow:(NSArray *)arry;

@end

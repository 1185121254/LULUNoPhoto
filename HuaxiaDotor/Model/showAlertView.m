//
//  showAlertView.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "showAlertView.h"

@implementation showAlertView

/**
 *  显示简单的文字提示
 *
 *  @param message 文字提示
 */
+(void)showAlertViewWithMessage:(NSString *)message
{
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil message:message cancelButtonTitle:@"确定"];
    cxAlertView.showBlurBackground = NO;
    [cxAlertView show];
    
}

/**
 *  只有文字提示
 *
 *  @param OnlyMessage 文字提示
 */
+(void)showAlertViewWithOnlyMessage:(NSString *)OnlyMessage
{
//    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil message:OnlyMessage cancelButtonTitle:nil];
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:NULL message:OnlyMessage cancelButtonTitle:nil];
    [cxAlertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cxAlertView dismiss];
    });
}

+(void)showAlertviewWithView:(UIView *)contentView confirmAction:(void (^)())confirmAction
{
    CXAlertView *cx = [[CXAlertView alloc]initWithTitle:nil contentView:contentView cancelButtonTitle:nil];
    cx.scrollViewPadding = 0;
    cx.containerWidth = contentView.frame.size.width;
    cx.titleColor = [UIColor colorWithRed:0.263 green:0.290 blue:0.329 alpha:1.000];
    cx.showBlurBackground = NO;
    cx.cancelButtonColor = [UIColor colorWithRed:0.196 green:0.741 blue:0.824 alpha:1.000];
    [cx addButtonWithTitle:@"确定" type:CXAlertViewButtonTypeCancel handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        confirmAction();
        [alertView dismiss];
    }];
    [cx addButtonWithTitle:@"取消" type:CXAlertViewButtonTypeCancel handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        [alertView dismiss];
    }];
    [cx show];
}

@end

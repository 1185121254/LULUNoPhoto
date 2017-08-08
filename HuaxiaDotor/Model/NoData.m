//
//  NoData.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/1.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "NoData.h"

static UILabel *_viewB;

@implementation NoData


+(UILabel *)singleNoDate:(UIView *)view center:(BOOL)isCenter{

    if (isCenter == YES) {
        _viewB = [[UILabel alloc]initWithFrame:CGRectMake(0, (kHeight-140)/2, kWith, 60)];
    }else
    {
        _viewB = [[UILabel alloc]initWithFrame:CGRectMake(0, (view.frame.size.height-60)/3, kWith, 60)];
    }
    _viewB.font = [UIFont systemFontOfSize:20];
    _viewB.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _viewB.text = @"无记录";
    _viewB.textAlignment =1;
    return _viewB;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
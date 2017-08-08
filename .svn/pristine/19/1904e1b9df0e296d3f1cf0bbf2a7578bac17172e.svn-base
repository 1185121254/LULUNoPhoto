//
//  ScheduleTableCollectionViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ScheduleTableCollectionViewCell.h"

@implementation ScheduleTableCollectionViewCell


-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        float width = (kWith-2)/4;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        _lblTime.textAlignment =1;
        _lblTime.textColor = [UIColor colorWithRed:98/255.0 green:185/255.0 blue:219/255.0 alpha:1];
        [self.contentView addSubview:_lblTime];
        
        _btnAdd  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAdd setTitle:@"+" forState:UIControlStateNormal];
        _btnAdd.titleLabel.font = [UIFont systemFontOfSize:22];
        [_btnAdd setTitleColor:[UIColor colorWithRed:98/255.0 green:185/255.0 blue:219/255.0 alpha:1] forState:UIControlStateNormal];
        _btnAdd.frame = _lblTime.frame;
        _btnAdd.hidden = YES;
        _btnAdd.tag = 601;
        [_btnAdd addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnAdd];
        
    }
    return self;
}

-(void)onBtn{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"Sched" object:self];
    
}

@end

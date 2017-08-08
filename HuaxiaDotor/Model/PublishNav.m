//
//  PublishNav.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/21.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PublishNav.h"

@implementation PublishNav

-(id)init{
    if (self = [super init]) {
        
        self.backgroundColor = BLUECOLOR_STYLE;
        self.frame = CGRectMake(0, 0, kWith, 64);
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, kWith, 40)];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:19];
        _title.textAlignment = 1;
        [self addSubview:_title];

        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 13, 22)];
        image.image = [UIImage imageNamed:@"返回"];
        image.transform = CGAffineTransformMakeRotation(M_PI*4);
        [self addSubview:image];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 20, 40, 44);
        [self addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightBtn];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

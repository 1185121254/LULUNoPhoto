//
//  MoneyDetailCollectionViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MoneyDetailCollectionViewCell.h"

@implementation MoneyDetailCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _lblColor = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 10, 10)];
        _lblColor.backgroundColor = [UIColor blueColor];
        _lblColor.layer.cornerRadius = 5;
        _lblColor.layer.masksToBounds = YES;
        [self.contentView addSubview:_lblColor];
        
        _lblType = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, frame.size.width - 30, 45)];
        _lblType.text = @"aa";
        _lblType.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_lblType];
        
        _lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, frame.size.width, 70 - 45)];
        _lblPrice.textColor = [UIColor orangeColor];
        _lblPrice.text = @"30";
        _lblPrice.textAlignment = 1;
        _lblPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_lblPrice];
        
    }
    return self;
}


@end

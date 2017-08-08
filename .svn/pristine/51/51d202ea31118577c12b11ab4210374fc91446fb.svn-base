//
//  DocAddCollectionViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DocAddCollectionViewCell.h"

@implementation DocAddCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _imageViewDoc = [[UIImageView alloc]initWithFrame:frame];
        _imageViewDoc.frame = CGRectMake(0, 0, kItemWidth, kItemWidth);
        _imageViewDoc.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageViewDoc];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, kItemWidth)];
        _lblName.font = [UIFont systemFontOfSize:15];
        _lblName.textColor = kBoradColor;
        _lblName.text = @"添加照片";
        [self.contentView addSubview:_lblName];
        
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setTitle:@"-" forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete.frame = CGRectMake(kItemWidth-20, 0, 20, 20);
        _btnDelete.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
        [self.contentView addSubview:_btnDelete];
        
        
    }
    return self;
}

-(void)onDelete{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePic" object:self];

}

@end

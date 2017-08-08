//
//  AddSchedTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddSchedTableViewCell.h"

@implementation AddSchedTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
        _lblTime.font = [UIFont systemFontOfSize:15];
        _lblTime.layer.borderWidth = 1;
        _lblTime.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
        _lblTime.textAlignment = 1;
        _lblTime.layer.cornerRadius = 3;
        _lblTime.layer.masksToBounds = YES;
        [self.contentView addSubview:_lblTime];
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 100, 30)];
        _lblCount.font = [UIFont systemFontOfSize:15];
        _lblCount.layer.borderWidth = 1;
        _lblCount.textAlignment = 1;
        _lblCount.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
        _lblCount.layer.cornerRadius = 3;
        [self.contentView addSubview:_lblCount];
        
        _btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTime.frame = _lblTime.frame;
        _btnTime.backgroundColor = [UIColor clearColor];
        [_btnTime addTarget:self action:@selector(onBtnhour) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnTime];
        
        _btnCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCount.frame = _lblCount.frame;
        _btnCount.backgroundColor = [UIColor clearColor];
        [_btnCount addTarget:self action:@selector(onBtnMin) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnCount];
        
        
        _btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReduce.frame = CGRectMake(kWith-45, 5, 40, 40);
        [_btnReduce setBackgroundImage:[UIImage imageNamed:@"-0"] forState:UIControlStateNormal];
        [_btnReduce addTarget:self action:@selector(onBtnReduce:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnReduce];
    }
    return self;
}

-(void)onBtnReduce:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reduceSched" object:self];

}

-(void)onBtnhour{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Timee" object:self];

}

-(void)onBtnMin{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Countt" object:self];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

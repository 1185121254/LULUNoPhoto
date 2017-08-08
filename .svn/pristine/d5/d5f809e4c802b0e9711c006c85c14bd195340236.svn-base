//
//  viedoAddTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "viedoAddTableViewCell.h"

@implementation viedoAddTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblStarTtime = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 30)];
        _lblStarTtime.font = [UIFont systemFontOfSize:13];
        _lblStarTtime.textAlignment = 1;
        _lblStarTtime.layer.borderWidth = 1;
        _lblStarTtime.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
        _lblStarTtime.textAlignment = 1;
        _lblStarTtime.layer.cornerRadius = 3;
        [self.contentView addSubview:_lblStarTtime];
        
        _btnStartTime = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnStartTime.frame = _lblStarTtime.frame;
        [_btnStartTime addTarget:self action:@selector(onStatar) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnStartTime];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(85, 20, 10, 10)];
        lbl.textAlignment = 1;
        lbl.text = @"~";
        [self.contentView addSubview:lbl];
        
        _lblEndTime = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 70, 30)];
        _lblEndTime.font = [UIFont systemFontOfSize:13];
        _lblEndTime.layer.borderWidth = 1;
        _lblEndTime.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
        _lblEndTime.textAlignment = 1;
        _lblEndTime.layer.cornerRadius = 3;
        _lblEndTime.textAlignment = 1;
        [self.contentView addSubview:_lblEndTime];
        
        _btnEndTime = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnEndTime.frame = _lblEndTime.frame;
        [_btnEndTime addTarget:self action:@selector(onEnd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnEndTime];
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 45-10 -60, 10, 60, 30)];
        _lblCount.font = [UIFont systemFontOfSize:13];
        _lblCount.layer.borderWidth = 1;
        _lblCount.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
        _lblCount.textAlignment = 1;
        _lblCount.layer.cornerRadius = 3;
        _lblCount.textAlignment = 1;
        [self.contentView addSubview:_lblCount];
        
        _btnCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCount.frame = _lblCount.frame;
        [_btnCount addTarget:self action:@selector(onCount) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnCount];
        
        _btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReduce.frame = CGRectMake(kWith-45, 5, 40, 40);
        [_btnReduce setBackgroundImage:[UIImage imageNamed:@"-0"] forState:UIControlStateNormal];
        [_btnReduce addTarget:self action:@selector(onBtnReduce) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnReduce];
        
    }
    return self;
}


-(void)onBtnReduce{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viedoReduce" object:self];
}

-(void)onEnd{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viedoEnd" object:self];

}

-(void)onStatar{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viedoStat" object:self];

}

-(void)onCount{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viedoCount" object:self];

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

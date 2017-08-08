//
//  SendReadyTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/28.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SendReadyTableViewCell.h"

@implementation SendReadyTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        float wifth =80/3;
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith-30, wifth)];
        _lblName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_lblName];
        
        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(10, wifth+5, (kWith-20)/2, wifth)];
        _lblDate.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _lblDate.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblDate];
        
        _lblReciver = [[UILabel alloc]initWithFrame:CGRectMake((kWith-20)/2, wifth+5, (kWith-20)/2-10, wifth)];
        _lblReciver.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _lblReciver.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblReciver];
        
        _lblDesp = [[UILabel alloc]initWithFrame:CGRectMake(10, wifth*2+5, kWith-20-10, wifth)];
        _lblDesp.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblDesp];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, kWith-20, 1)];
        line.backgroundColor = kBoradColor;
        [self.contentView addSubview:line];
    }
    return self;
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

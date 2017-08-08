//
//  MoneyDetailTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MoneyDetailTableViewCell.h"

@implementation MoneyDetailTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith - 20, 25)];
        _lblTime.font = [UIFont systemFontOfSize:14];
        _lblTime.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_lblTime];
        
        _lblType = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kWith - 20, 25)];
        _lblType.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblType];
        
        _lblMoney = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 70, 5, 80, 50)];
        _lblMoney.textColor = [UIColor redColor];
        _lblMoney.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_lblMoney];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, kWith-20, 1)];
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

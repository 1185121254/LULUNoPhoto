//
//  CaseDiscussTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseDiscussTableViewCell.h"

@implementation CaseDiscussTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, (kWith - 20)/2, 30)];
        [self.contentView addSubview:_lblName];
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake((kWith - 20)/2, 5, 150, 30)];
        _lblTime.textAlignment = 2;
        _lblTime.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        _lblTime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblTime];
        
        _lblDesp = [[UILabel alloc]init];
        _lblDesp.frame = CGRectMake(10, 45,kWith-40, 20);
        _lblDesp.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        _lblDesp.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblDesp];
        
        _lblNewMeg = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 30, 40, 18, 18)];
        _lblNewMeg.backgroundColor = [UIColor redColor];
        _lblNewMeg.font = [UIFont systemFontOfSize:14];
        _lblNewMeg.textAlignment = 1;
        _lblNewMeg.layer.cornerRadius = 9;
        _lblNewMeg.layer.masksToBounds = YES;
        _lblNewMeg.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_lblNewMeg];
        
        _line = [[UILabel alloc]init];
        _line.frame = CGRectMake(10, 70, kWith-20, 1);
        _line.backgroundColor = kBoradColor;
        [self.contentView addSubview:_line];
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

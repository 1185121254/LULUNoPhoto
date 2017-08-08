//
//  AddressTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageAvater = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        _imageAvater.layer.cornerRadius = 30;
        _imageAvater.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageAvater];
        
        _lblNewMeg = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 10, 10)];
        _lblNewMeg.backgroundColor = [UIColor redColor];
        _lblNewMeg.layer.cornerRadius = 5;
        _lblNewMeg.layer.masksToBounds = YES;
        [_imageAvater addSubview:_lblNewMeg];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, kWith - 90, 35)];
        [self.contentView addSubview:_lblName];
        
        _lblIllness = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, kWith - 90, 35)];
        _lblIllness.font = [UIFont systemFontOfSize:14];
        _lblIllness.textColor = kBoradColor;
        [self.contentView addSubview:_lblIllness];
       

        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kWith-20, 1)];
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

//
//  OnLineTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "OnLineTableViewCell.h"

@implementation OnLineTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _avater = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 56, 56)];
        [self.contentView addSubview:_avater];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(76, 10, kWith-76, 30)];
        _lblName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_lblName];
        
        _lblFunction = [[UILabel alloc]initWithFrame:CGRectMake(76, 60, kWith-76, 20)];
        _lblFunction.textColor = [UIColor grayColor];
        _lblFunction.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblFunction];
        
        _lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(76, 40, kWith-76, 20)];
        _lblPrice.textColor = [UIColor redColor];
        _lblPrice.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblPrice];

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

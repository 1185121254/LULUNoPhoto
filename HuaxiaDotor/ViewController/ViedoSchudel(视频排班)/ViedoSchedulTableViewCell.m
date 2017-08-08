//
//  ViedoSchedulTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ViedoSchedulTableViewCell.h"

@implementation ViedoSchedulTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith- 70 -20, 10, 60, 40)];
        _lblCount.font = [UIFont systemFontOfSize:13];
        _lblCount.textAlignment =1;
        _lblCount.numberOfLines = 0;
        [self.contentView addSubview:_lblCount];
        
        
        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
        _lblDate.font = [UIFont systemFontOfSize:13];
        _lblDate.textAlignment = 1;
        _lblDate.numberOfLines = 0;
        [self.contentView addSubview:_lblDate];
        
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

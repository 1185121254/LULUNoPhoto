//
//  FreeDiagnoseHTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FreeDiagnoseHTableViewCell.h"

@implementation FreeDiagnoseHTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, kWith-60, 20)];
        _lblDate.font = [UIFont systemFontOfSize:15];
        _lblDate.textColor = kBoradColor;
        [self.contentView addSubview:_lblDate];
        
        _lblType = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, kWith-60, 20)];
        _lblType.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblType];
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith-70, 5, 60, 40)];
        _lblCount.textAlignment = 2;
        _lblCount.textColor = [UIColor colorWithRed:251/255.0 green:110/255.0 blue:82/255.0 alpha:1];
        _lblCount.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_lblCount];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, kWith-10, 1)];
        lbl.backgroundColor = kBoradColor;
        [self.contentView addSubview:lbl];
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

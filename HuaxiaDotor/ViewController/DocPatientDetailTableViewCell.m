//
//  DocPatientDetailTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DocPatientDetailTableViewCell.h"

@implementation DocPatientDetailTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 25)];
        lblTime.font = [UIFont systemFontOfSize:14];
        lblTime.textColor = kBoradColor;
        lblTime.text = @"开始时间：";
        [self.contentView addSubview:lblTime];
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, kWith - 100, 25)];
        _lblTime.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblTime];
        
        
        UILabel *lblAdvice = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 80, 25)];
        lblAdvice.font = [UIFont systemFontOfSize:14];
        lblAdvice.textColor = kBoradColor;
        lblAdvice.text = @"医嘱：";
        [self.contentView addSubview:lblAdvice];

        _lblAdvice = [[UILabel alloc]initWithFrame:CGRectMake(90, 25, kWith - 100, 25)];
        _lblAdvice.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblAdvice];
        
        UILabel *lblType = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 25)];
        lblType.font = [UIFont systemFontOfSize:14];
        lblType.textColor = kBoradColor;
        lblType.text = @"类型：";
        [self.contentView addSubview:lblType];
        
        _lblType = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, kWith - 100, 25)];
        _lblType.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblType];
        
        _lblState = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 80, 50, 70, 25)];
        _lblState.textAlignment = TextAlignmentRight;
        _lblState.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblState];
        
        
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

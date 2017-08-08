//
//  PatientDetailTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientDetailTableViewCell.h"

@implementation PatientDetailTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //==============================
        _lblTime  =  [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 90, 20)];
        _lblTime.textAlignment = 1;
        _lblTime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblTime];
        
        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 90, 20)];
        _lblDate.textAlignment = 1;
        _lblDate.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblDate];
        
        _lblSource = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 90, 20)];
        _lblSource.textAlignment = 1;
        _lblSource.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblSource];
        
        _lblLine = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 1, 110)];
        _lblLine.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_lblLine];
        
        _roundView = [[UIView alloc]initWithFrame:CGRectMake(110, 20, 20, 20)];
        _roundView.layer.cornerRadius = 10;
        _roundView.layer.masksToBounds = YES;
        [self.contentView addSubview:_roundView];
        
        _lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, kWith-170, 40)];
        _lblDescription.numberOfLines = 0;
        _lblDescription.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblDescription];
        
    }
    return self;
}

- (NSString *)setSource:(NSInteger)source{
    if (source == 1) {
        return @"平台";
    }
    else if (source == 2)
    {
        return @"医院";
    }
    else if (source == 3)
    {
        return @"新增";
    }
    return 0;
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

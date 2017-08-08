//
//  DoctorAdvieTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DoctorAdvieTableViewCell.h"

@implementation DoctorAdvieTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblBedNum = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 70, 25)];
        _lblBedNum.font = [UIFont systemFontOfSize:14];
        _lblBedNum.textColor = kBoradColor;
        _lblBedNum.text = @"床号：";
        [self.contentView addSubview:_lblBedNum];
        
        _lblMuBedNum = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, kWith/2-90, 25)];
        _lblMuBedNum.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblMuBedNum];
        
        _lblHospicalNum = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2, 5, 70, 25)];
        _lblHospicalNum.font = [UIFont systemFontOfSize:14];
        _lblHospicalNum.textColor = kBoradColor;
        _lblHospicalNum.text = @"住院号：";
        [self.contentView addSubview:_lblHospicalNum];
        
        _lblMuHospicalNum = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2+10+60, 5, kWith - kWith/2 - 10 - 70, 25)];
        _lblMuHospicalNum.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblMuHospicalNum];
        
        _lblPropertyNum = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 70, 25)];
        _lblPropertyNum.font = [UIFont systemFontOfSize:14];
        _lblPropertyNum.textColor = kBoradColor;
        _lblPropertyNum.text = @"性质：";
        [self.contentView addSubview:_lblPropertyNum];
        
        _lblMuPropertyNum = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, kWith/2-90, 25)];
        _lblMuPropertyNum.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblMuPropertyNum];
        
        _lblArrears =[[UILabel alloc]initWithFrame:CGRectMake(kWith/2, 35, 70, 25)];
        _lblArrears.font = [UIFont systemFontOfSize:14];
        _lblArrears.textColor = kBoradColor;
        _lblArrears.text = @"欠费：";
        [self.contentView addSubview:_lblArrears];
        
        _lblMuArrears  = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2+10+60, 35, kWith - kWith/2 - 10 - 70, 25)];
        _lblMuArrears.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblMuArrears];
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

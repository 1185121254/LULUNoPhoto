//
//  AcademicTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AcademicTableViewCell.h"

@implementation AcademicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(NSDictionary *)dic
{
    NSString *str = dic[@"picFileName"];
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    [_image_Head sd_setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:[UIImage imageNamed:@"i-门诊记录"]];
    _lbl_title.text = dic[@"newsTitle"];
    _lbl_time.text = dic[@"newsTime"];
}



@end

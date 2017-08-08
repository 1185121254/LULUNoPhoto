//
//  HospitalNameTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "HospitalNameTableViewCell.h"

@implementation HospitalNameTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

/**
 *  设置表格
 *
 *  @param dic  表格的字典数据
 *  @param type 表格的数据内容 1 为医院名字, 2 为职称名字 3 为级别名字
 */
-(void)setCell:(NSDictionary *)dic type:(int)type select:(NSString *)str
{
    if (type==1)
    {
        _lbl_hospitalName.text = dic[@"hosName"];
    }
    else if(type==2)
    {
        _lbl_hospitalName.text = dic[@"name"];
    }
    else if (type==3)
    {
        _lbl_hospitalName.text = dic[@"name"];
    }
    if ([str isEqualToString:_lbl_hospitalName.text])
    {
        [_image_select setImage:[UIImage imageNamed:@"i圈_h"]];
    }
    else
    {
        [_image_select setImage:[UIImage imageNamed:@"i圈"]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CaseDetailNameTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseDetailNameTableViewCell.h"

@implementation CaseDetailNameTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /////////
        _lblDespci = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
        _lblDespci.font = [UIFont systemFontOfSize:15];
        _lblDespci.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_lblDespci];
        
        _lblName = [[UILabel alloc]init];
        _lblName.textAlignment = 2;
        _lblName.numberOfLines = 0;
        _lblName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblName];
        
        _lbl = [[UILabel alloc]init];
        _lbl.backgroundColor = kBoradColor;
        [self.contentView addSubview:_lbl];
    }
    return self;
}

-(void)setCaseCommHeight:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 100, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _lblName.frame = CGRectMake(80, 10, kWith-100, rect.size.height);
    _lblName.text = text;
    _lbl.frame =CGRectMake(10, rect.size.height+19, kWith-20, 1);
}

+(CGFloat)setHeightCaseCommName:(NSString *)text{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 70 -10, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    return rect.size.height;
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

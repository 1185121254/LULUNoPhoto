//
//  DetailReaflyTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DetailReaflyTableViewCell.h"

@implementation DetailReaflyTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblDesp = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 70, 20)];
        _lblDesp.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _lblDesp.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblDesp];
        
        _lblText = [[UILabel alloc]init];
        _lblText.numberOfLines = 0;
        [self.contentView addSubview:_lblText];
    }
    return self;
}

-(void)setHeightCell:(NSString *)text isOne:(BOOL)isOne Font:(NSInteger)font{

    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith-90, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (isOne == YES) {
        _lblText.frame = CGRectMake(20, 5, kWith-40, rect.size.height);
    }else
    {
        _lblText.frame = CGRectMake(80, 5, kWith-90, rect.size.height);
    }
    _lblText.font = [UIFont systemFontOfSize:font];
    _lblText.text = text;
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

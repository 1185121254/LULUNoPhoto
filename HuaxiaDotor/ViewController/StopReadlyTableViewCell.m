
//
//  StopReadlyTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "StopReadlyTableViewCell.h"

@implementation StopReadlyTableViewCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblDesp = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
        _lblDesp.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        _lblDesp.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblDesp];
        
        _lblText = [[UILabel alloc]init];
        _lblText.numberOfLines = 0;
        _lblText.font =[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblText];
    }
    return self;
}


-(void)setHeightCellStop:(NSString *)text{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith-140, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _lblText.frame = CGRectMake(120, 5, kWith-140, rect.size.height);
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

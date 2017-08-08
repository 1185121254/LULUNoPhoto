//
//  KeyClipTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KeyClipTableViewCell.h"

@implementation KeyClipTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageAvater = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        _imageAvater.layer.cornerRadius = 25;
        _imageAvater.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageAvater];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, kWith - 80, 30)];
        _lblName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblName];
        
        _lblAgeSex = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, kWith - 80, 30)];
        _lblAgeSex.font = [UIFont systemFontOfSize:14];
        _lblAgeSex.textColor = kBoradColor;
        [self.contentView addSubview:_lblAgeSex];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kWith-20, 1)];
        lbl.backgroundColor = kBackgroundColor;
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

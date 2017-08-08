//
//  PatentTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatentTableViewCell.h"

@implementation PatentTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _avater                        = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 56, 56)];
        _avater.layer.cornerRadius     = 28;
        _avater.layer.masksToBounds    = YES;
        [self.contentView addSubview:_avater];

        _lblName                       = [[UILabel alloc]initWithFrame:CGRectMake(_avater.frame.origin.x+_avater.frame.size.width+15, 15, kWith-135-_avater.frame.origin.x-_avater.frame.size.width-10, 15)];
        _lblName.textColor             = [UIColor colorWithRed:67/255.0 green:74/255.0 blue:84/255.0 alpha:1];
        _lblName.font                  = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblName];

        _lblTime                       = [[UILabel alloc]initWithFrame:CGRectMake(kWith-135, 15, 125, 15)];
        _lblTime.font                  = [UIFont systemFontOfSize:12];
        _lblTime.textColor             = [UIColor colorWithRed:169/255.0 green:179/255.0 blue:191/255.0 alpha:1];
        _lblTime.textAlignment         = 2;
        [self.contentView addSubview:_lblTime];

        _lblText                       = [[UILabel alloc]init];
        _lblText.frame                 = CGRectMake(_avater.frame.origin.x+_avater.frame.size.width+20, 35,kWith - 60-13-50, 30);
        _lblText.textColor             = [UIColor colorWithRed:169/255.0 green:179/255.0 blue:191/255.0 alpha:1];
        _lblText.font                  = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblText];

        _lblNewMeg                     = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 30, 40, 18, 18)];
        _lblNewMeg.backgroundColor     = [UIColor redColor];
        _lblNewMeg.font                = [UIFont systemFontOfSize:14];
        _lblNewMeg.textAlignment       = 1;
        _lblNewMeg.layer.cornerRadius  = 9;
        _lblNewMeg.layer.masksToBounds = YES;
        _lblNewMeg.textColor           = [UIColor whiteColor];
        [self.contentView addSubview:_lblNewMeg];

        UILabel *line                  = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, kWith-20, 1)];
        line.backgroundColor           = kBoradColor;
        [self.contentView addSubview:line];
    }
    
    return self;
}

-(void)setCellLblFrom:(NSString *)text{
   
//    CGRect size = [text boundingRectWithSize:CGSizeMake(kWith - 60-13-30, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

    _lblText.text = text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

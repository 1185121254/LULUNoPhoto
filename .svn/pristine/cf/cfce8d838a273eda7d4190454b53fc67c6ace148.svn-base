//
//  KZANTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/1.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KZANTableViewCell.h"

@implementation KZANTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCell:(NSDictionary *)dic
{
    NSString *imageUrl = dic[@"picFileName"];
    imageUrl=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,imageUrl];
    NSString *strUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    _image_head.layer.cornerRadius = _image_head.frame.size.height/2;
    _image_head.layer.masksToBounds = YES;
    
    _lbl_name.text = dic[@"userName"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SeachFriendTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SeachFriendTableViewCell.h"

@implementation SeachFriendTableViewCell

-(void)setCell:(NSDictionary *)dic
{
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl]];
    _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
    [_image_head.layer setMasksToBounds:YES];
    
    _lbl_name.text = dic[@"userName"];
    _lbl_Department.text = dic[@"speciality"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

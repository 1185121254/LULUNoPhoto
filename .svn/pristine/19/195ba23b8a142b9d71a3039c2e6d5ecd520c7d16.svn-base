//
//  FriendTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(NSDictionary *)dic
{
    _lbl_name.text = dic[@"userName"];
    _lbl_hospital.text = dic[@"licenseHospital"];
    
    NSString *url_image = dic[@"picFileName"];
    url_image = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,url_image];
    url_image=[url_image stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:url_image]];
    _image_head.layer.cornerRadius = _image_head.frame.size.height/2;
    _image_head.layer.masksToBounds = YES;
}

@end

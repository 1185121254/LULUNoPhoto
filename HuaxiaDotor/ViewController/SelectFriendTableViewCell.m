//
//  SelectFriendTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/11.
//  Copyright © 2016年 kock. All rights reserved.
//6666667778

#import "SelectFriendTableViewCell.h"

@implementation SelectFriendTableViewCell

-(void)setCell:(NSMutableDictionary *)dic patient:(BOOL)patient andSelect:(BOOL)select
{
     //医生的数据设置
    if (patient==NO)
    {
        _lbl_name.text = dic[@"userName"];
        NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
        imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
        _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
        [_image_head.layer setMasksToBounds:YES];
    }
    //病人的数据设置
    else if (patient==YES)
    {
        _lbl_name.text = dic[@"name"];
        NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picfileName"]];
        imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon"]];
        _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
        [_image_head.layer setMasksToBounds:YES];
    }
    
    if (select==YES)
    {
        [_image_select setImage:[UIImage imageNamed:@"i圈_h"]];
    }
    if (select==NO)
    {
        [_image_select setImage:[UIImage imageNamed:@"i圈"]];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

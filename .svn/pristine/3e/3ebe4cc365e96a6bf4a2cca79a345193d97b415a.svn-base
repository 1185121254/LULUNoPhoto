//
//  DialogueTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DialogueTableViewCell.h"

@implementation DialogueTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(NSDictionary *)dic
{
    _lbl_title.text = dic[@"userName"];
    if (dic[@"reviewerName"]==nil)
    {
        _lbl_info.text = dic[@"commentDetail"];
    }
    else
    {
        NSString *str_info;

        NSString *str_name = dic[@"reviewerName"];
        str_info = [NSString stringWithFormat:@"回复%@: %@",str_name,dic[@"commentDetail"]];
        NSMutableAttributedString *str_talk = [[NSMutableAttributedString alloc]initWithString:str_info];
        [str_talk addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BLUECOLOR_STYLE, NSForegroundColorAttributeName, nil] range:NSMakeRange(2, str_name.length)];
        _lbl_info.attributedText = str_talk;
    }
    
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl]];
    
    _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
    [_image_head.layer setMasksToBounds:YES];
}

@end

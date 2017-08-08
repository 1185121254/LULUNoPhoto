//
//  EyeReviewTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "EyeReviewTableViewCell.h"

@implementation EyeReviewTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setCellForEyeInfo:(NSDictionary *)dic withImageURL:(NSString *)url
{
    self.lblListName.text=dic[@"checkName"];
    self.lblListInfo.text=dic[@"description"];
    
    url=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,url];
    NSString *strUrl=[url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:strUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  PhotoPreviewTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/13.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "PhotoPreviewTableViewCell.h"

@implementation PhotoPreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoPreviewImage.contentMode = UIViewContentModeScaleAspectFill;
    self.photoPreviewImage.clipsToBounds = YES;

}

-(void)setCell:(NSDictionary *)dic DicData:(NSDictionary *)dicData{
    [self.photoPreviewImage  sd_setImageWithURL:[NSURL URLWithString:[self replaceLine:dic[@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"感叹号"]];
    if ([dicData[@"state"] integerValue] == 2) {
        self.photoSource.text = [NSString stringWithFormat:@"评分:    %d",[dic[@"score"] integerValue]];
        self.photoSource.hidden = NO;
        self.soureHeight.constant = 20;
    }else{
        self.photoSource.hidden = YES;
        self.soureHeight.constant = 0;
    }
}

-(NSString *)replaceLine:(NSString *)url{
    return [[NSString stringWithFormat:@"%@%@",NET_URLSTRING,url] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

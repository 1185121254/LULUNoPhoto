//
//  CaseDetailComPicTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseDetailComPicTableViewCell.h"

@implementation CaseDetailComPicTableViewCell

-(void)setCaseCommImageFraem:(NSMutableArray *)arry{
    
    float width = ((kWith - 20)-3*10)/4;
    
    for (NSInteger i = 0; i < arry.count; i ++) {
        UIImageView *image = [[UIImageView alloc]init];
        
        NSDictionary *dic = arry[i];
        NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picUrl"]];
        NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
        image.frame  = CGRectMake(10+(width+10)*(i%4), 5+(width+5)*(i/4), width, width);
        [self.contentView addSubview:image];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = image.frame;
        btn.tag = 1230+i;
        [btn addTarget:self action:@selector(onBtnCAsePicList:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
    }
}

-(void)onBtnCAsePicList:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CAsePicList" object:@(btn.tag)];
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

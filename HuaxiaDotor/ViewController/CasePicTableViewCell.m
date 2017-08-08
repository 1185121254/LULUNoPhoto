//
//  CasePicTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CasePicTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation CasePicTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _btnAddImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAddImage addTarget:self action:@selector(onBTnCaseAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnAddImage];
        
    }
    return self;
}

-(void)onBTnCaseAdd{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CaseAddImage" object:self];
    
}

//-(void)setImageFraem:(NSMutableArray *)arry{
//    
//    for (UIView *view in self.contentView.subviews) {
//        if (![view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//        }
//    }
//    
//    float width = ((kWith - 20)-3*20)/4;
//    
//    for (NSInteger i = 0; i < arry.count + 1; i ++) {
//        if (i == arry.count) {
//            [_btnAddImage setBackgroundImage:[UIImage imageNamed:@"添加照片"] forState:UIControlStateNormal];
//            _btnAddImage.frame = CGRectMake(10+(width+20)*(i%4), 5+(width+5)*(i/4), width, width);
//        }else
//        {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame  = CGRectMake(10+(width+20)*(i%4), 5+(width+5)*(i/4), width, width);
//            ALAsset *asset=arry[i];
//            CGImageRef posterImageRef=[asset thumbnail];
//            UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
//            btn.tag = 2100+i;
//            [btn addTarget:self action:@selector(onBtnBig:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setImage:posterImage forState:UIControlStateNormal];
//            [self.contentView addSubview:btn];
//        }
//    }
//}

//-(void)onBtnBig:(UIButton *)btn{
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"CaseBig" object:@(btn.tag - 2100)];
//    
//}


-(void)setPicOtherImageFraem:(NSMutableArray *)arry{

    for (UIView *view in self.contentView.subviews) {
        if (![view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    NSInteger count = kWith/60;
    NSInteger reste = (NSInteger)kWith % 60;
    float gap = reste/(count + 1);
    for (NSInteger i = 0; i < arry.count + 1; i ++) {
        if (i == arry.count) {
            [_btnAddImage setBackgroundImage:[UIImage imageNamed:@"l+"] forState:UIControlStateNormal];
            _btnAddImage.layer.cornerRadius = 60/2;
            _btnAddImage.layer.masksToBounds = YES;
            _btnAddImage.frame = CGRectMake(gap+(60+gap)*(i%count), gap+(60+gap)*(i/count), 60, 60);
        }
        else
        {
            UIImageView *image = [[UIImageView alloc]init];
            image.contentMode = UIViewContentModeScaleAspectFit;
            NSDictionary *dic = arry[i];
            NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picFileName"]];
            NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
            image.layer.cornerRadius = 60/2;
            image.layer.masksToBounds = YES;
            image.frame  = CGRectMake(gap+(60+gap)*(i%count), gap+(60+gap)*(i/count), 60, 60);
            [self.contentView addSubview:image];
        }
    }
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

//
//  PatientShowInTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientShowInTableViewCell.h"

@implementation PatientShowInTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCell:(NSMutableDictionary *)dic
{
    self.doctorName.text = dic[@"userName"];
    if (dic[@"licenseTitle"] == nil) {
        self.doctorGread.hidden = YES;
    }else{
        self.doctorGread.hidden = NO;
        self.doctorGread.text = dic[@"licenseTitle"];
    }
    self.doctorGread.layer.cornerRadius=3;
    self.doctorGread.layer.masksToBounds=YES;
    
    self.hospital.text = dic[@"licenseHospital"];
    self.sendTime.text = dic[@"createDate"];
    self.caseTitle.text = [NSString stringWithFormat:@"#%@#",dic[@"title"]];
    
    if ([[dic allKeys]containsObject:@"illness"])
    {
        NSString *sex = dic[@"sex"];
        NSString *strSex = [[NSString alloc]init];
        if ([sex isEqualToString:@"1"])
        {
            strSex = @"男性患者";
        }
        else if ([sex isEqualToString:@"0"])
        {
            strSex = @"女性患者";
        }
        NSString *age = dic[@"age"];
        //诊断
        NSString *illness =dic[@"illness"];
        //描述
        NSString *illDetail = dic[@"illDetail"];
        //备注
        NSString *detail = dic[@"detail"];
        if (!dic[@"detail"])
        {
            self.caseInfo.text = [NSString stringWithFormat:@"%@，%@岁，症状:%@，诊断:%@",strSex,age,illDetail,illness];
        }
        else
        {
             self.caseInfo.text = [NSString stringWithFormat:@"%@，%@岁，症状:%@，诊断:%@，备注:%@",strSex,age,illDetail,illness,detail];
        }
    }
    else
    {
        self.caseInfo.text = dic[@"detail"];
    }

    self.lblStart.text = [dic[@"upvoteCount"] stringValue];
    self.lblInfo.text = [dic[@"commentCount"] stringValue];
    self.lblCollect.text = [dic[@"collectCount"]stringValue];
    self.lblStart.text = [dic[@"upvoteCount"]stringValue];
    
    NSString *heaeImaeUrl = dic[@"picFileName"];
    heaeImaeUrl=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,heaeImaeUrl];
    NSString *strUrl=[heaeImaeUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=self.headImage.frame.size.height/2;
    
    NSMutableArray *ImageArr=dic[@"picList"];
    NSMutableDictionary *imageDic=ImageArr[0];
    NSString *imageQuickUrl = imageDic[@"picUrl"];
    imageQuickUrl=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,imageQuickUrl];
    NSString *imageStrUrl=[imageQuickUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_viewForQuickImage sd_setImageWithURL:[NSURL URLWithString:imageStrUrl] placeholderImage:[UIImage imageNamed:@"感叹号"]];
    self.viewForQuickImage.contentMode = UIViewContentModeScaleAspectFill;
    self.viewForQuickImage.clipsToBounds = YES;
    self.imageQuickCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)ImageArr.count];
    
    if (![dic objectForKey:@"picList"])
    {
        _heightForImageView.constant = 0;
        _viewForShowCount.hidden = YES;
    }
    else
    {
        _heightForImageView.constant = 159;
        _viewForShowCount.hidden = NO;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MassageTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MassageTableViewCell.h"

@implementation MassageTableViewCell

-(void)setCell:(NSMutableDictionary *)dic
{
    
    int i = (int)[dic[@"type"] integerValue];
    NSString *docName = dic[@"publisherName"];
    if (i==1)
    {
        _lbl_FormMassage.text = @"来自:系统广播";
    }
    else if (i==2)
    {
        _lbl_FormMassage.text =[NSString stringWithFormat:@"来自%@的群发通知",docName];
    }
    else if (i==3)
    {
        _lbl_FormMassage.text = @"来自:停诊通知";
    }
    
    _lbl_titleMassage.text = dic[@"messageTitle"];
    
    _lbl_MassageInfo.text = dic[@"messageDetail"];
    
    _lbl_timeMassage.text = dic[@"createDate"];
    
    //缺少站内消息的通知title
    NSInteger read = [[dic objectForKey:@"isRead"] integerValue];
    if (read == 0) {
        //未读
        _lbl_titleMassage.textColor = [UIColor blackColor];
        _lbl_MassageInfo.textColor = [UIColor blackColor];

    }else
    {
        //已读
        _lbl_titleMassage.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _lbl_MassageInfo.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
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

//
//  CaseNameTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseNameTableViewCell.h"

@implementation CaseNameTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblDespci = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
        _lblDespci.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblDespci];
        
        _btnXunFly = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnXunFly.frame = CGRectMake(kWith - 30, 7, 30, 25);
        [_btnXunFly addTarget:self action:@selector(onXunfly) forControlEvents:UIControlEventTouchUpInside];
        [_btnXunFly setImage:[UIImage imageNamed:@"i语音"] forState:UIControlStateNormal];
//        [_btnXunFly setBackgroundImage:[UIImage imageNamed:@"i语音"] forState:UIControlStateNormal];
        [self.contentView addSubview:_btnXunFly];
        
        _Casetext = [[UITextView alloc]init];
        _Casetext.delegate = self;
//        _Casetext.backgroundColor = [UIColor redColor];
        _Casetext.font = [UIFont systemFontOfSize:15];
        _Casetext.frame = CGRectMake(100, 5, kWith - 120-30, 30);
        [self.contentView addSubview:_Casetext];
        
        _placelor = [[UILabel alloc]initWithFrame:CGRectMake(107, 3, 100, 30)];
        _placelor.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        _placelor.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_placelor];
        
    }
    return self;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _placelor.hidden = NO;
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placelor.hidden = YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placelor.hidden = NO;
    }else
    {
        _placelor.hidden = YES;
    }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (textView.tag == 894||textView.tag == 414||textView.tag == 415) {
            if (textView.text .length>100) {
                NSString *outLength = [textView.text substringWithRange:NSMakeRange(100, textView.text.length-100)];
                textView.text =  [textView.text stringByReplacingOccurrencesOfString:outLength withString:@""];
                [dic setObject:@"不能超过100个字符" forKey:@"error"];
            }
        }
        else{
            if (textView.text .length>50) {
                NSString *outLength = [textView.text substringWithRange:NSMakeRange(50, textView.text.length-50)];
                textView.text = [textView.text stringByReplacingOccurrencesOfString:outLength withString:@""];
                [dic setObject:@"不能超过50个字符" forKey:@"error"];
            }
        }
        [dic setObject:self forKey:@"cell"];
        [dic setObject:textView.text forKey:@"text"];
        [dic setObject:textView forKey:@"textView"];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"CaseNameText" object:nil userInfo:dic];
}

-(void)onXunfly{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CaseXunFly" object:self];
}

-(void)patientTextCellHeight:(NSString *)text Desp:(NSString *)desp Placelor:(NSString *)placelor isHeight:(BOOL)isHeight{
    
    if ([text isEqualToString:@""]) {
        _placelor.hidden = NO;
    }else
    {
        _placelor.hidden = YES;
    }
    if (isHeight) {
        CGRect rect  = _Casetext.frame;
        rect.size.height = 60;
        _Casetext.frame = rect;
    }else
    {
        CGRect rect  = _Casetext.frame;
        rect.size.height = 30;
        _Casetext.frame = rect;
    }
    _Casetext.text = text;
    _lblDespci.text = desp;
    _placelor.text = placelor;
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

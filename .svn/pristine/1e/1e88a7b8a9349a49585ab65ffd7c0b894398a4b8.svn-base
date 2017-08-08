//
//  AdviceTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AdviceTableViewCell.h"

@implementation AdviceTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _dicText = [NSMutableDictionary dictionary];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kWith-20, 80)];
//        _textView.backgroundColor = [UIColor redColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        _textView.delegate = self;
        [self.contentView addSubview:_textView];
        
        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWith-20, 30)];
        _lbl.font = [UIFont systemFontOfSize:15];
        _lbl.textColor = kBoradColor;
        [self.contentView addSubview:_lbl];
    }
    return self;
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.text.length == 0) {
        _lbl.hidden = NO;
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _lbl.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _lbl.hidden = NO;
    }else
    {
        _lbl.hidden = YES;
        [_dicText setObject:self forKey:@"cell"];
        [_dicText setObject:_textView.text forKey:@"txt"];
        if (textView.text.length>100) {
            NSString *outLength = [textView.text substringWithRange:NSMakeRange(100, textView.text.length-100)];
            textView.text =  [textView.text stringByReplacingOccurrencesOfString:outLength withString:@""];
            [_dicText setObject:@"不能超出100个字符" forKey:@"error"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddDocAdviceText" object:nil userInfo:_dicText];
    }
}

-(void)textViewHeightTxt:(NSString *)text place:(NSString *)place Source:(NSString *)from Advice:(AdviewDetail *)advice{

    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if ([from isEqualToString:@"BeenDia"]) {
        _textView.frame = CGRectMake(10, 0, kWith-20, rect.size.height+15);
    }
    else if ([from isEqualToString:@"BennOver"]){
        if (advice.result != nil && ![advice.result isEqualToString:@""]) {
            _textView.frame = CGRectMake(10, 0, kWith-20, rect.size.height+10);
        }else
        {
//            [_textView becomeFirstResponder];
            _textView.frame = CGRectMake(10, 0, kWith-20, 80);
        }
    }else
    {
//        [_textView becomeFirstResponder];
        _textView.frame = CGRectMake(10, 0, kWith-20, 80);
    }
    
    _lbl.text = place;
    _textView.text = text;
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

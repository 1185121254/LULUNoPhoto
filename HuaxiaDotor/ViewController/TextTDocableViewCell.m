//
//  TextTDocableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "TextTDocableViewCell.h"

@implementation TextTDocableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _dicData = [NSMutableDictionary dictionary];
        
        _textViewDoc = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kWith - 20, 80)];
        _textViewDoc.delegate = self;
        _textViewDoc.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_textViewDoc];
        
        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kWith-20, 30)];
        _lbl.text = @"请输入";
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
        [_dicData setObject:self forKey:@"cell"];
        [_dicData setObject:textView.text forKey:@"txt"];
        if (textView.text.length>50) {
            [_dicData setObject:@"不能超出50个字符" forKey:@"error"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addDocTextView" object:nil userInfo:_dicData];
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

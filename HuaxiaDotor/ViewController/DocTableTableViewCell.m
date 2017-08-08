//
//  DocTableTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DocTableTableViewCell.h"

@implementation DocTableTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 40)];
        _lblName.font = [UIFont systemFontOfSize:15];
        _lblName.text = @"疾病诊断:";
        [self.contentView addSubview:_lblName];
        
        _textContent = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, kWith-100, 40)];
        _textContent.borderStyle = UITextBorderStyleNone;
        _textContent.placeholder = @"请输入";
        _textContent.delegate = self;
        _textContent.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_textContent];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"addDocTextFiled" object:textField.text];
    
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

//
//  ResultTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, kWith-40, 40)];
        _textFiled.placeholder = @"请输入初步预诊";
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.layer.cornerRadius = 4;
        _textFiled.layer.masksToBounds = YES;
     
        if ([kUserDefatuel objectForKey:@"result"] == nil || [[kUserDefatuel objectForKey:@"result"] isEqualToString:@""]) {
            _textFiled.text = @"";
        }
        else
        {
            _textFiled.text = [kUserDefatuel objectForKey:@"result"];
        }
        
        _textFiled.delegate = self;
        [self.contentView addSubview:_textFiled];
        
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [kUserDefatuel setObject:textField.text forKey:@"result"];
    
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

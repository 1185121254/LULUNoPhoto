//
//  MedicineTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MedicineTableViewCell.h"

@implementation MedicineTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, kWith-115-20, 40)];
        [self.contentView addSubview:_lblName];
        
        _count = [[UITextField alloc]initWithFrame:CGRectMake(kWith-110, 10, 60, 30)];
        _count.textAlignment = 1;
        _count.layer.cornerRadius = 4;
        _count.layer.masksToBounds = YES;
        _count.layer.borderWidth = 1;
        _count.text = @"";
        _count.delegate = self;
        _count.keyboardType = UIKeyboardTypeNumberPad;
        _count.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self.contentView addSubview:_count];
        
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAdd.frame = CGRectMake(kWith-45, 10, 30, 30);
        [_btnAdd setBackgroundImage:[UIImage imageNamed:@"ic_chat"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnAdd];
    }
    return self;
}

-(void)setText:(NSString *)name Unit:(NSString *)unit{

    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:name];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[name rangeOfString:unit]];
    _lblName.attributedText = medStr;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textField.text,@"text",self,@"self", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextAddCount" object:nil userInfo:dic];
    
}

-(void)onBtn:(UIButton *)btn{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"addCount" object:self];
    
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

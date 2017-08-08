//
//  PublishFreeTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PublishFreeTableViewCell.h"

@implementation PublishFreeTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 40)];
        _lblTitle.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_lblTitle];
        
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setBackgroundImage:[UIImage imageNamed:@"-0"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete.frame = CGRectMake(kWith-45, 5, 40, 40);
        [self.contentView addSubview:_btnDelete];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, kWith-10, 1)];
        lbl.backgroundColor = kBoradColor;
        [self.contentView addSubview:lbl];
        
        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(5, 53, 60, 30)];
        _lblDate.text = @"就诊日期";
        _lblDate.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblDate];
        
        _lblDatePicker = [[UILabel alloc]initWithFrame:CGRectMake(70, 53, 100, 40)];
        _lblDatePicker.textAlignment = 1;
        _lblDatePicker.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:251/255.0 alpha:1];
        _lblDatePicker.layer.cornerRadius = 3;
        _lblDatePicker.layer.masksToBounds = YES;
        _lblDatePicker.layer.borderWidth = 1;
        _lblDatePicker.layer.borderColor = [kBoradColor CGColor];
        _lblDatePicker.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblDatePicker];
        
        _btnDatePicker = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDatePicker addTarget:self action:@selector(onPublishAdd) forControlEvents:UIControlEventTouchUpInside];
        _btnDatePicker.frame = _lblDatePicker.frame;
        [self.contentView addSubview:_btnDatePicker];
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith-70-10-60, 53, 60, 30)];
        _lblCount.text = @"就诊数量";
        _lblCount.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblCount];
        
        _lblCountPicker = [[UILabel alloc]initWithFrame:CGRectMake(kWith-70-5, 53, 60, 40)];
        _lblCountPicker.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:251/255.0 alpha:1];
        _lblCountPicker.textAlignment = 1;
        _lblCountPicker.layer.cornerRadius = 3;
        _lblCountPicker.layer.masksToBounds = YES;
        _lblCountPicker.layer.borderWidth = 1;
        _lblCountPicker.font = [UIFont systemFontOfSize:14];
        _lblCountPicker.layer.borderColor = [kBoradColor CGColor];
        [self.contentView addSubview:_lblCountPicker];
    
        _btnCountPicker = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCountPicker.frame = _lblCountPicker.frame;
        [_btnCountPicker addTarget:self action:@selector(onPublishredue) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnCountPicker];
    
    }
    return self;
}


-(void)onPublishredue{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PublishReduce" object:self];

}


-(void)onPublishAdd{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PublishAdd" object:self];

}

-(void)onDelete{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PublishDelete" object:self];
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

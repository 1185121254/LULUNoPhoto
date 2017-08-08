//
//  AddForManagerCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddForManagerCell.h"

@implementation AddForManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    }

-(void)setCell:(NSDictionary *)dic
{
    _btn_already.layer.cornerRadius = 3;
    _btn_already.layer.masksToBounds = YES;
    _btn_delay.layer.cornerRadius = 3;
    _btn_delay.layer.masksToBounds = YES;
    
    NSString *name;
    if (dic[@"patientName"] == nil) {
        name= @"未填写";
    }else{
        name =dic[@"patientName"];
    }
    _lbl_name.text = name;
    
    int i = (int)[dic[@"sex"]integerValue];
    if (i==0)
    {
        _lbl_sex.text = @"女";
    }
    else
    {
        _lbl_sex.text = @"男";
    }
    
    if (dic[@"age"] == nil) {
        _lbl_age.text = @"未填写";
    }else
    {
        _lbl_age.text = [NSString stringWithFormat:@"%@岁", dic[@"age"]];
    }
    _lbl_timeForAgree.text = [NSString stringWithFormat:@"%@  %@-%@",dic[@"appointmentDate"],[dic objectForKey:@"appointmentTime"],[dic objectForKey:@"appointmentTime2"]];

    _lbl_symptom.text = dic[@"description"];
    NSNumber *visState = dic[@"visState"];
    if ([visState intValue]==0)
    {
        _btn_delay.backgroundColor = [UIColor greenColor];
        _btn_delay.userInteractionEnabled = YES;
        _btn_already.backgroundColor = BLUECOLOR_STYLE;
        _btn_already.userInteractionEnabled = YES;
    }
    else if ([visState intValue]==1)
    {
        _btn_delay.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.152];
        _btn_delay.userInteractionEnabled = NO;
        _btn_already.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.152];
        _btn_already.userInteractionEnabled = NO;
    }
    else if ([visState intValue]==2)
    {
        _btn_delay.backgroundColor =[UIColor colorWithWhite:0.000 alpha:0.152];
        _btn_delay.userInteractionEnabled = NO;
        _btn_already.backgroundColor = BLUECOLOR_STYLE;
        _btn_already.userInteractionEnabled = YES;
    }
    _dic_cellData = [[NSDictionary alloc]init];
    _dic_cellData = dic;
    
}

- (IBAction)btnAlready:(UIButton *)sender
{
    [self.delegate sendCellData:_dic_cellData and:1 andCell:self];
    
//    NSLog(@"11");
}

- (IBAction)btnDelay:(UIButton *)sender
{
    [self.delegate sendCellData:_dic_cellData and:2 andCell:self];
//    NSLog(@"22");
}


@end

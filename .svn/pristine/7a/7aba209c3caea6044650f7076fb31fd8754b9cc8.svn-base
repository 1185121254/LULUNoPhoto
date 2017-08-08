//
//  ReportTableTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ReportTableTableViewCell.h"

@implementation ReportTableTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageAvater = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 50, 50)];
        _imageAvater.layer.cornerRadius = 25;
        _imageAvater.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageAvater];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, kWith - 200, 30)];
        [self.contentView addSubview:_lblName];
        
        _lblIllness = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, kWith - 80 - 60, 14)];
        _lblIllness.font = [UIFont systemFontOfSize:14];
        _lblIllness.textColor = kBoradColor;
        [self.contentView addSubview:_lblIllness];
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(70, 51, kWith - 80, 14)];
        _lblTime.font = [UIFont systemFontOfSize:14];
        _lblTime.textColor = kBoradColor;
        [self.contentView addSubview:_lblTime];
        
        _btnState = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnState.frame = CGRectMake(kWith-70, 20, 60, 30);
        _btnState.layer.cornerRadius = 3;
        _btnState.layer.masksToBounds = YES;
        [_btnState addTarget:self action:@selector(onBtnReport) forControlEvents:UIControlEventTouchUpInside];
        _btnState.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_btnState];
        
        _lblLastTime = [[UILabel alloc]initWithFrame:CGRectMake(_lblName.frame.origin.x+_lblName.frame.size.width, 14, kWith-_lblName.frame.origin.x-_lblName.frame.size.width, 15)];
        _lblLastTime.font = [UIFont systemFontOfSize:13];
        _lblLastTime.textColor = kBoradColor;
        [self.contentView addSubview:_lblLastTime];
        
        _lblNewMeg = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 30, 40, 18, 18)];
        _lblNewMeg.backgroundColor = [UIColor redColor];
        _lblNewMeg.font = [UIFont systemFontOfSize:14];
        _lblNewMeg.textAlignment = 1;
        _lblNewMeg.layer.cornerRadius = 9;
        _lblNewMeg.layer.masksToBounds = YES;
        _lblNewMeg.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_lblNewMeg];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kWith-20, 1)];
        line.backgroundColor = kBoradColor;
        [self.contentView addSubview:line];
        
    }
    return self;
}

-(void)setPatientData:(NSDictionary *)dic state:(NSString *)state{

    NSString *sex;
    if ([[dic objectForKey:@"sex"] integerValue] == 1) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    NSString *age;
    if ([dic objectForKey:@"age"] == nil) {
        age = @"未填写";
    }else
    {
        age = [dic objectForKey:@"age"];
    }
    _lblName.attributedText = [self setNameText:[NSString stringWithFormat:@"%@  %@ %@",[dic objectForKey:@"name"],sex,age]];
    [_imageAvater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",NET_URLSTRING]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    if ([dic objectForKey:@"diagnosisResult"]) {
        _lblIllness.text = [NSString stringWithFormat:@"初步预诊:%@",[dic objectForKey:@"diagnosisResult"]];
    }else
    {
        _lblIllness.text = @"初步预诊:未填写";
    }
    
    if ([state isEqualToString:@"0"]) {
        _btnState.hidden = NO;
        [_btnState setTitle:@"接受" forState:UIControlStateNormal];
        _btnState.userInteractionEnabled = YES;
        [_btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnState.backgroundColor = BLUECOLOR_STYLE;
        _lblNewMeg.hidden = YES;
        _lblLastTime.hidden = YES;
        _lblTime.hidden = NO;
        NSString *oldDate = [dic objectForKey:@"treatmentDate"];
        NSString *creatDate = [oldDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        if (creatDate) {
            _lblTime.text = [NSString stringWithFormat:@"最近就诊:%@",creatDate];
        }else
        {
            _lblTime.text = @"最近就诊:未填写";
        }
    }else
    {
        NSString *oldDate = [dic objectForKey:@"latestDate"];
        NSString *creatDate = [oldDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        if (creatDate) {
            _lblLastTime.text = creatDate;
        }else
        {
            _lblLastTime.text = @"";
        }
        _lblLastTime.hidden = NO;
        _lblTime.hidden = YES;
        _btnState.hidden = YES;
        if ([[dic objectForKey:@"newMessage"] integerValue] == 0) {
            _lblNewMeg.hidden = YES;
        }else
        {
            _lblNewMeg.hidden = NO;
            _lblNewMeg.text = [dic objectForKey:@"newMessage"];
        }
    }
    

}
//富文本
-(NSMutableAttributedString *)setNameText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(void)onBtnReport{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"reportPatient" object:self];
    
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

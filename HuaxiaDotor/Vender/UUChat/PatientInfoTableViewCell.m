//
//  PatientInfoTableViewCell.m
//  HuaxiaPatient
//
//  Created by 欧阳晓隆 on 16/4/28.
//  Copyright © 2016年 欧阳晓隆. All rights reserved.
//

#import "PatientInfoTableViewCell.h"

@implementation PatientInfoTableViewCell
{
    __weak IBOutlet UILabel *sendTime;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *sex;
    __weak IBOutlet UILabel *age;
    __weak IBOutlet UILabel *symptom;
    
}
-(void)setDataWithDic:(NSDictionary *)dic
{
    NSDictionary *dicValue = [dic objectForKey:@"value"];
    
    sendTime.text = dicValue[@"sendTime"];
    name.text = dicValue[@"name"];
    sex.text = [dicValue objectForKey:@"sex"];
    age.text = dicValue[@"age"];
    symptom.text = dicValue[@"symptom"];
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

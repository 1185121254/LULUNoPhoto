//
//  MessageCustomCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MessageCustomCell.h"

@implementation MessageCustomCell


-(void)messageCustomCell:(NSDictionary *)dic  AvterURL:(NSString *)url{

    
    NSDictionary *dicValue = [dic objectForKey:@"value"];
        
    self.name.text = [NSString stringWithFormat:@"%@  %@  %@岁",[dicValue objectForKey:@"name"],[dicValue objectForKey:@"sex"],[dicValue objectForKey:@"age"]];
    self.connect.text = [dicValue objectForKey:@"symptom"];
    
    [self.avter sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon"]];
    
    self.nameAvDown.text = [dicValue objectForKey:@"name"];
    self.nameAvDown.textAlignment = 1;
    if (dicValue[@"tel"]) {
        [self.patientTel setTitle:dicValue[@"tel"] forState:UIControlStateNormal];
    }
    
    UIImage *normal;
    normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    self.qiPao.image = normal;
    
//    self.bottomVIew.layer.mask = self.qiPao.layer;
    self.qiPao.alpha = 0.7;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.avter.layer.cornerRadius = 20;
    self.avter.layer.masksToBounds = YES;
    self.nameAvDown.textColor = [UIColor grayColor];
    
}

- (IBAction)btnClickAvter:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dlickAvter" object:nil];
    
}

- (IBAction)clickPhoneNum:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickPhoneNum" object:sender];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ElePationTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 17/5/8.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "ElePationTableViewCell.h"

@implementation ElePationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDicModel:(NSDictionary *)dicModel{

    if (dicModel) {
        
        self.lbl_name.text = dicModel[@"patientName"];
        self.lbl_age.text = dicModel[@"age"];
        self.lbl_bedNum.text = dicModel[@"bedNo"];
        self.lbl_nameSep.text = dicModel[@"deptName"];
        self.lbl_paNum.text = dicModel[@"patientId"];
        self.lbl_inquNum.text = dicModel[@"eventNo"];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

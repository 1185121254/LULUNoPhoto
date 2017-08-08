//
//  MyPatientsTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/3/30.
//  Copyright © 2016年 kock. All rights reserved.
//  我的患者 预约

#import <UIKit/UIKit.h>

@interface MyPatientsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblID;

@property (weak, nonatomic) IBOutlet UILabel *lblApmDate;

//是否就诊过
@property (weak, nonatomic) IBOutlet UIButton *btnCheckout;
//用户数据字典
@property (weak, nonatomic) NSDictionary *userDataDic;

@property (weak, nonatomic) IBOutlet UILabel *TimeLbl;


/**
 *  设置患者信息Cell
 *
 *  @param dic 患者信息字典
 */
-(void)setCellPatient:(NSDictionary *)dic andBtnHidden:(BOOL)hidden;

@end

//
//  MassageTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MassageTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbl_titleMassage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_timeMassage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FormMassage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MassageInfo;



-(void)setCell:(NSMutableDictionary *)dic;

@end

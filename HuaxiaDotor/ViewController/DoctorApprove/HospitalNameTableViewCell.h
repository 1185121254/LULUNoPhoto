//
//  HospitalNameTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_hospitalName;
@property (weak, nonatomic) IBOutlet UIImageView *image_select;
-(void)setCell:(NSDictionary *)dic type:(int)type select:(NSString *)str;
@end

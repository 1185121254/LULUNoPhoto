//
//  DetailReaflyTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/7/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailReaflyTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *lblDesp;
@property(nonatomic,strong)UILabel *lblText;

-(void)setHeightCell:(NSString *)text isOne:(BOOL)isOne Font:(NSInteger)font;
@end

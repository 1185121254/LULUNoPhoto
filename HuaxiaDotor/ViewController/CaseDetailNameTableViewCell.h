//
//  CaseDetailNameTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDetailNameTableViewCell : UITableViewCell
{
    UILabel *_lbl;
}
@property(nonatomic,strong)UILabel *lblDespci;
@property(nonatomic,strong)UILabel *lblName;

-(void)setCaseCommHeight:(NSString *)text;
+(CGFloat)setHeightCaseCommName:(NSString *)text;

@end

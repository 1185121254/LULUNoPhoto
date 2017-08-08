//
//  CaseNameTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseNameTableViewCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic,strong)UILabel *lblDespci;
@property(nonatomic,strong)UITextView *Casetext;
@property(nonatomic,strong)UIButton *btnXunFly;
@property(nonatomic,strong)UILabel *placelor;

-(void)patientTextCellHeight:(NSString *)text Desp:(NSString *)desp Placelor:(NSString *)placelor isHeight:(BOOL)isHeight;


@end

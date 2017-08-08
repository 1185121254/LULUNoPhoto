//
//  AddForManagerCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/6/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddForManagerCell;
@protocol AddCellDelegate <NSObject>
-(void)sendCellData:(NSDictionary *)dic  and:(NSInteger)visState andCell:(AddForManagerCell*)cell;
@end

@interface AddForManagerCell : UITableViewCell

@property (strong, nonatomic) id <AddCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sex;
@property (weak, nonatomic) IBOutlet UILabel *lbl_age;
@property (weak, nonatomic) IBOutlet UILabel *lbl_timeForAgree;
@property (weak, nonatomic) IBOutlet UILabel *lbl_symptom;

//已就诊
@property (weak, nonatomic) IBOutlet UIButton *btn_already;

//延期
@property (weak, nonatomic) IBOutlet UIButton *btn_delay;

-(void)setCell:(NSDictionary *)dic;

@property (strong, nonatomic) NSDictionary *dic_cellData;

@end

//
//  AddviceMedTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddviceMedTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UIButton *btnReduce;
@property(nonatomic,strong)UILabel *lblCount;
@property(nonatomic,strong)UIButton *btnAdd;
-(void)setText:(NSString *)name;

@end

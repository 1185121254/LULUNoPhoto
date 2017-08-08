//
//  SelectCityTableViewCell.m
//  HuaxiaPatient
//
//  Created by 欧阳晓隆 on 16/3/28.
//  Copyright © 2016年 欧阳晓隆. All rights reserved.
//

#import "SelectCityTableViewCell.h"

@implementation SelectCityTableViewCell
{
    __weak IBOutlet UIImageView *selectedProvinceCell;
    __weak IBOutlet NSLayoutConstraint *selectedShowConstraint;
    __weak IBOutlet NSLayoutConstraint *selectedHiddenConstraint;
    __weak IBOutlet UILabel *provinceLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithLabel:(NSString *)label cellIdentifier:(NSString *)identifier selectIndex:(NSInteger)selectIndex currentIndex:(NSInteger)currentIndex
{
    provinceLabel.text = label;
    if ([identifier isEqualToString:@"city"]) {
        [self cityCellSetting];
    }else{
        if (selectIndex == currentIndex) {
            [self provinceCellSelected];
        }else{
            [self provinceCellUnselected];
        }
    }
}
-(void)provinceCellSelected
{
    selectedProvinceCell.hidden = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    selectedShowConstraint.priority = UILayoutPriorityDefaultHigh;
    selectedHiddenConstraint.priority = UILayoutPriorityDefaultLow;
}
-(void)provinceCellUnselected
{
    selectedProvinceCell.hidden = YES;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    selectedShowConstraint.priority = UILayoutPriorityDefaultLow;
    selectedHiddenConstraint.priority = UILayoutPriorityDefaultHigh;
}
-(void)cityCellSetting
{
    selectedProvinceCell.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    selectedShowConstraint.priority = UILayoutPriorityDefaultHigh;
    selectedHiddenConstraint.priority = UILayoutPriorityDefaultLow;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

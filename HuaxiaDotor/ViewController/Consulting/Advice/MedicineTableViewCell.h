//
//  MedicineTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicineTableViewCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UITextField *count;
@property(nonatomic,strong)UIButton *btnAdd;

-(void)setText:(NSString *)name Unit:(NSString *)unit;

@end

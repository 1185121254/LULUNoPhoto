//
//  ResultTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultTableViewCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textFiled;

@end
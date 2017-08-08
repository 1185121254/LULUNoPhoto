//
//  SelectFriendTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/11.
//  Copyright © 2016年 kock. All rights reserved.
//  选择联系人

#import <UIKit/UIKit.h>

@interface SelectFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_select;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

-(void)setCell:(NSMutableDictionary*)dic patient:(BOOL)patient andSelect:(BOOL)select;

@end

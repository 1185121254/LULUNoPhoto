//
//  SeachFriendTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SeachFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Department;

-(void)setCell:(NSDictionary*)dic;

@end
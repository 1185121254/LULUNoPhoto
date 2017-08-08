//
//  DialogueTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_dialogue;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_info;

-(void)setCell:(NSDictionary *)dic;




@end

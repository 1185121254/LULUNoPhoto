//
//  AcademicTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcademicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;

-(void)setCell:(NSDictionary *)dic;

@end

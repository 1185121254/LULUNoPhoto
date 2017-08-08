//
//  WordTableViewCell.h
//  HuaxiaDotor
//
//  Created by kock on 16/4/14.
//  Copyright © 2016年 kock. All rights reserved.
//  单词cell

#import <UIKit/UIKit.h>

@interface WordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)setCell:(NSMutableDictionary*)dic;

@end

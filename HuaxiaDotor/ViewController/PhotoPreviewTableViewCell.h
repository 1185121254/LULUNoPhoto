//
//  PhotoPreviewTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 17/3/13.
//  Copyright © 2017年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soureHeight;

@property (weak, nonatomic) IBOutlet UILabel *lableLine;
@property (weak, nonatomic) IBOutlet UIImageView *photoPreviewImage;
@property (weak, nonatomic) IBOutlet UILabel *photoSource;

-(void)setCell:(NSDictionary *)dic DicData:(NSDictionary *)dicData;

@end
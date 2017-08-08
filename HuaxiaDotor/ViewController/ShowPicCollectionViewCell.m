//
//  ShowPicCollectionViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ShowPicCollectionViewCell.h"

@implementation ShowPicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)btnDelete:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"picDelete" object:self];
}


@end

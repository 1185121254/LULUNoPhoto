//
//  CollectionViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/7/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
}

-(void)setCell:(NSDictionary*)dic
{
    _image_head.layer.masksToBounds = YES;
    _image_head.layer.cornerRadius = _image_head.frame.size.height/2;
    
}

@end

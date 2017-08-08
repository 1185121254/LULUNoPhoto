//
//  LongPressRestClip.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongPressRestClip : UILongPressGestureRecognizer

@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,copy)NSString *longId;

@end

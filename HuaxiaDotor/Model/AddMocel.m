//
//  AddMocel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddMocel.h"

@implementation AddMocel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        _Id = (NSString *)value;
    }
}
@end

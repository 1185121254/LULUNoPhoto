//
//  PhoneModel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PhoneModel.h"

@implementation PhoneModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _Id = (NSString *)value;
    }
}

@end

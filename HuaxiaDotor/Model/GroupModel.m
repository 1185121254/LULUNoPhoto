//
//  GroupModel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        _Id = (NSString *)value;
    }

}

-(id)init{
    if (self = [super init]) {
        _groupDetail = [NSMutableArray array];
    }
    return self;
}

@end

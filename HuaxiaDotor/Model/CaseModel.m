//
//  CaseModel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseModel.h"

@implementation CaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"newMessage"]) {
        _NewMessage = (NSString *)value;
    }
}

@end

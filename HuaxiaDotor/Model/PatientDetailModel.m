//
//  PatientDetailModel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientDetailModel.h"

@implementation PatientDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        _Id = (NSString *)value;
    }
}

-(id)init{
    if (self = [super init]) {
        _consultationList = [[NSMutableArray alloc]init];
        _caseList = [[NSMutableArray alloc]init];
    }
    return self;
}

@end

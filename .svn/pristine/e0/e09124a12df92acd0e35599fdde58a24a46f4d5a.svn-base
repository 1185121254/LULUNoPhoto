
//
//  PatientModel.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientModel.h"

@implementation PatientModel

-(id)init{
    if (self = [super init]) {
        _picList= [[NSArray alloc]init];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"description"]) {
        _Description = (NSString *)value;
    }
    if ([key isEqualToString:@"id"]) {
        _Id = (NSString *)value;
    }
    if ([key isEqualToString:@"tel"] || [key isEqualToString:@"patientTel"]) {
        _patientTel = (NSString *)value;
    }
}

@end

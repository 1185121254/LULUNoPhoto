//
//  Anasisy.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "Anasisy.h"
#import "WebClinicModel.h"
#import "CaseModel.h"
#import "FriendModel.h"
@implementation Anasisy


+(NSMutableArray *)setHeight:(NSMutableArray *)arry{

    NSMutableArray *arryHeight = [NSMutableArray array];

    
    for (WebClinicModel *model in arry) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (model.picList.count == 0) {
            
            CGRect rect = [model.illDetail boundingRectWithSize:CGSizeMake(kWith - 20, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            [dic setObject:@(80 + rect.size.height +10) forKey:@"height"];
        }
        else{
          CGRect rect = [model.illDetail boundingRectWithSize:CGSizeMake(kWith - 20, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            [dic setObject:@(220 + rect.size.height +10) forKey:@"height"];

        }
        [arryHeight addObject:dic];
    }
    
    return arryHeight;
}




+(NSMutableArray *)seCasetHeight:(NSMutableArray *)arry{
    
    NSMutableArray *arryHeight = [NSMutableArray array];
    
    for (CaseModel *model in arry) {
        
        CGRect rect = [[NSString stringWithFormat:@"症状描述%@",model.illness] boundingRectWithSize:CGSizeMake(kWith - 20, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
  
        [arryHeight addObject:@(40 + rect.size.height + 10)];
    }
    return arryHeight;
}

+(NSMutableArray *)setDateMonth:(NSArray *)arry{

    NSMutableArray *arryAll = [NSMutableArray array];
    NSMutableArray *arryNow = [NSMutableArray array];
    NSMutableArray *arryNext = [NSMutableArray array];
    NSMutableArray *arryNextTwo = [NSMutableArray array];
    
    NSCalendar *calendarNow = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsNow = nil;
    compsNow = [calendarNow components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *adcompsNow = [[NSDateComponents alloc] init];
    [adcompsNow setYear:0];
    [adcompsNow setMonth:0];
    NSDate *newdateNow = [calendarNow dateByAddingComponents:adcompsNow toDate:[NSDate date] options:0];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    NSCalendar *calendarNext = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsNext = nil;
    compsNext = [calendarNext components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *adcompsNext = [[NSDateComponents alloc] init];
    [adcompsNext setYear:0];
    [adcompsNext setMonth:-2];
    NSDate *newdateNext = [calendarNext dateByAddingComponents:adcompsNext toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    
    for (NSDictionary *dicValue in arry) {
        NSString *date = [dicValue objectForKey:@"createDate"];
        NSArray *arryDate = [date componentsSeparatedByString:@"-"];
        NSString *dateCreatS = [NSString stringWithFormat:@"%@-%@",arryDate[0],arryDate[1]];
        
        if ([dateCreatS isEqualToString: [dateFormat stringFromDate:newdateNow]]) {
            [arryNow addObject:dicValue];
        }
        if ([dateCreatS isEqualToString: [dateFormat stringFromDate:newdate]]) {
            [arryNext addObject:dicValue];
        }
        if ([dateCreatS isEqualToString: [dateFormat stringFromDate:newdateNext]]) {
            [arryNextTwo addObject:dicValue];
        }
    }    
    [arryAll addObject:arryNow];
    [arryAll addObject:arryNext];
    [arryAll addObject:arryNextTwo];
    return arryAll;
}


@end

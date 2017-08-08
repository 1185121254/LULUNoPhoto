//
//  CaseModel.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseModel : NSObject

@property (nonatomic,copy ) NSString *age;
@property (nonatomic,copy ) NSString *createDate;
@property (nonatomic,copy ) NSString *disId;
@property (nonatomic,copy ) NSString *doctorId;
@property (nonatomic,copy ) NSString *illness;
@property (nonatomic,copy ) NSString *patientName;
@property (nonatomic,copy ) NSString *sex;
@property (nonatomic,copy ) NSString *picList;
@property (nonatomic,copy ) NSString *teamId;
@property (nonatomic,copy ) NSString *diagnosisResult;

@property (nonatomic, copy) NSString * latestDate;
@property (nonatomic, copy) NSString * NewMessage;



@end

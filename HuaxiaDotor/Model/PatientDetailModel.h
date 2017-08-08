//
//  PatientDetailModel.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientDetailModel : NSObject

@property(nonatomic,copy)NSString *assType;
@property(nonatomic,copy)NSString *birth;
@property(nonatomic,strong)NSMutableArray *consultationList;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *illness;
@property(nonatomic,copy)NSString *medicalCard;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,strong)NSMutableArray *caseList;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *isFocus;
@property(nonatomic,copy)NSString *picfilepatient;
@property(nonatomic,copy)NSString *caseNo;

@property(nonatomic,copy)NSString *clinicId;


@end

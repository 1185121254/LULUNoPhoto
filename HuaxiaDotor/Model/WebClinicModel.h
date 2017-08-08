//
//  WebClinicModel.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebClinicModel : NSObject

@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *collectCount;
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSString *doctorId;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *illDetail;
@property(nonatomic,copy)NSString *illness;
@property(nonatomic,copy)NSString *licenseDept;
@property(nonatomic,copy)NSString *licenseHospital;
@property(nonatomic,copy)NSString *licenseTitle;
@property(nonatomic,copy)NSString *patientName;
@property(nonatomic,copy)NSString *picFileName;
@property(nonatomic,strong)NSMutableArray *picList;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *upvoteCount;
@property(nonatomic,copy)NSString *userName;

@end

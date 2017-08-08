//
//  Attachment.h
//  HuaxiaPatient
//
//  Created by 欧阳晓隆 on 16/4/24.
//  Copyright © 2016年 欧阳晓隆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"

@interface Attachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
@property (nonatomic, strong)NSNumber *flag;
@property (nonatomic, strong)NSDictionary *patientDic;
@end

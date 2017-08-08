//
//  Attachment.m
//  HuaxiaPatient
//
//  Created by 欧阳晓隆 on 16/4/24.
//  Copyright © 2016年 欧阳晓隆. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment
-(NSString *)encodeAttachment
{
    NSDictionary *dic = @{CMType : @([self.flag integerValue]),
                          CMData : @{CMValue:self.patientDic}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *encodeString = @"";
    if (data) {
        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return encodeString;
}
@end

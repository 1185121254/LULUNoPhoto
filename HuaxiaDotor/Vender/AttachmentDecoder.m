//
//  AttachmentDecoder.m
//  HuaxiaPatient
//
//  Created by 欧阳晓隆 on 16/4/24.
//  Copyright © 2016年 欧阳晓隆. All rights reserved.
//

#import "AttachmentDecoder.h"
#import "Attachment.h"

@implementation AttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            Attachment *myAttachment = [[Attachment alloc] init];
            myAttachment.flag = [dict objectForKey:@"type"];
            myAttachment.patientDic = [dict objectForKey:@"data"];
            attachment = myAttachment;
        }
    }
    return attachment;
}
@end

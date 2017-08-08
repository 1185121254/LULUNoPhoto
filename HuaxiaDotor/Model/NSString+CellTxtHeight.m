//
//  NSString+CellTxtHeight.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "NSString+CellTxtHeight.h"

@implementation NSString (CellTxtHeight)

+(CGFloat)cellHeight:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+20;
}

#pragma mark--------升序有model类
+(NSArray *)shengXuPatientConC:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSArray * array = [arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {
        
        NSDate *date1 = [dateFormatter dateFromString:modelM1.latestDate];
        NSDate *date2 = [dateFormatter dateFromString:modelM2.latestDate];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    return array;
}


#pragma mark--------富文本
+(NSAttributedString *)richTextOldStr:(NSString *)oldText SeparatedByString:(NSString *)sepStr strUnit:(NSInteger)wave textFont:(UIFont *)font textForgColor:(UIColor *)color{

    NSArray *arry = [oldText componentsSeparatedByString:sepStr];
    NSString *strUnit = arry[wave];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:oldText];
   
    [attributeStr addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:[oldText rangeOfString:strUnit]];
    
    return attributeStr;
}

#pragma mark--------下载路径
+(NSURL *)downLoadFile:(NSString *)patientName FileNmae:(NSString *)title{

    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",patientName]] isDirectory:& isDir]) {
        
        BOOL creaatSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",patientName]] withIntermediateDirectories:YES attributes:nil error:nil];
        if (creaatSuccess) {
            NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.docx",patientName,title]];
            NSLog(@"--------%@",filePath);
            
            NSURL*urlFile = [NSURL fileURLWithPath:filePath];
            return urlFile;
        }else
        {
            NSLog(@"创建文件夹失败");
            return 0;
        }
        
    }else
    {
        NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.docx",patientName,title]];
        NSLog(@"--------%@",filePath);
        
        NSURL*urlFile = [NSURL fileURLWithPath:filePath];
        return urlFile;
    }

}

#pragma mark--------获取患者手机号
+(NSString *)getPatientTel:(PatientModel *)model{
    
    if (model.patientIM) {
        NSString *tel = [model.patientIM stringByReplacingOccurrencesOfString:@"p" withString:@""];
        return tel;
    }else
    {
        return 0;
    }

}

#pragma mark--------医生是否是第一次发消息

+(void)isFristMsgDoctor:(BOOL)isFristMsg Patient:(NSString *)patientTel type:(NSString *)type  viewController:(UIViewController *)vc Compent:(void(^)(BOOL isFrirt))compent{

    //医生没有发过消息
    if (isFristMsg == NO) {
        
        NSDictionary *dic = [kUserDefatuel objectForKey:@"DoctorDataDic"];
        
        NSString *MOBILE = @"^1[34578]\\d{9}$";
        NSPredicate *regexTestMobile = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",MOBILE];
        if ([regexTestMobile evaluateWithObject:patientTel]) {

            NSDictionary *para = @{@"tel":patientTel,@"doctorName":dic[@"userName"],@"type":type};
            [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/His/SendMessage",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:vc success:^(id responseObject, BOOL ifTimeout) {
                
                compent(YES);

            } failure:^(NSError *error) {
                compent(NO);
            }];
                        
        }else
        {
            compent(YES);
        }
    }else
    {

        compent(YES);

    }
}

#pragma mark--------是否有医生发的这条消息
+(void)isDoctorRead:(BOOL)isRead OrderId:(NSString *)orderId viewController:(UIViewController *)vc  Compent:(void(^)(BOOL isRead))compent{

    if (isRead == NO) {
        NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
        [Dic setValue:orderId forKey:@"orderId"];
        [Dic setValue:@"5" forKey:@"state"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/TextOrdeTypeUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:Dic viewConroller:vc success:^(id responseObject) {
             compent(YES);
        } failure:^(NSError *error) {
            compent(NO);
        }];

    }else
    {
        compent(YES);
    }

}


#pragma mark - 颜色渐变
+ (CAGradientLayer *)shadowAsInverseCGRect:(CGRect )rect EndColor:(UIColor *)endColor
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = rect;
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合
    
    UIColor *beginColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:217/255.0 alpha:1];
    
    //设置渐变颜色方向
    newShadow.startPoint = CGPointMake(0, 0);
    newShadow.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    newShadow.colors = @[(__bridge id)beginColor.CGColor,
                         (__bridge id)endColor.CGColor];
    
    //设定颜色分割点
    newShadow.locations = @[@(0.5f) ,@(1.0f)];
    
    return newShadow;
}

@end

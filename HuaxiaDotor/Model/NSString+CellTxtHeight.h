//
//  NSString+CellTxtHeight.h
//  HuaxiaDotor
//
//  Created by ydz on 16/7/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CellTxtHeight)


+(CGFloat)cellHeight:(NSString *)text;

+(NSArray *)shengXuPatientConC:(NSArray *)arry;

#pragma mark--------富文本
+(NSAttributedString *)richTextOldStr:(NSString *)oldText SeparatedByString:(NSString *)sepStr strUnit:(NSInteger)wave textFont:(UIFont *)font textForgColor:(UIColor *)color;

#pragma mark--------下载路径
+(NSURL *)downLoadFile:(NSString *)patientName FileNmae:(NSString *)title;

#pragma mark--------医生是否是第一次发消息
+(void)isFristMsgDoctor:(BOOL)isFristMsg Patient:(NSString *)patientTel type:(NSString *)type viewController:(UIViewController *)vc Compent:(void(^)(BOOL isFrirt))compent;
#pragma mark--------是否有医生发的这条消息
+(void)isDoctorRead:(BOOL)isRead OrderId:(NSString *)orderId viewController:(UIViewController *)vc  Compent:(void(^)(BOOL isRead))compent;
#pragma mark--------获取患者手机号
+(NSString *)getPatientTel:(PatientModel *)model;

#pragma mark--------颜色渐变
+ (CAGradientLayer *)shadowAsInverseCGRect:(CGRect )rect EndColor:(UIColor *)endColor;
@end

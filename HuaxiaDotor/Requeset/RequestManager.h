//
//  RequestManager.h
//  HuaxiaDotor
//
//  Created by kock on 16/3/21.
//  Copyright © 2016年 kock. All rights reserved.
//  网络请求处理文件

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PatientDetailModel.h"
#import "AdviewDetail.h"
#import "MBProgressHUD.h"

@interface RequestManager : NSObject

/**
 *  简单 POST 请求 返回字典 有成功失败
 *
 *  @param url        请求地址
 *  @param parameters 参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+(void)postWithURLString:(NSString *)url
              parameters:(id)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  POST 请求 (包括HEAD)
 *
 *  @param url        请求网址
 *  @param heads      头文件
 *  @param parameters 参数
 *  @param shhuccess  请求成功回调
 *  @param failure    请求失败回调
 */
+(void)postWithURLString:(NSString *)url
                   heads:(NSDictionary *)heads
              parameters:(id)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;


/**
 *  GET 请求 (包含HEAD)
 *
 *  @param url        请求网址
 *  @param heads      头文件
 *  @param parameters 参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+(void)getWithURLString:(NSString *)url
                  heads:(NSDictionary *)heads
             parameters:(id)parameters
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

//医生获得患者列表
+(void)getTextOrderListURL:(NSString *)url heads:(NSDictionary *)heads parameters:(id)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSMutableArray *arry))complation Fail:(void(^)(NSError *error))fail;

//判断是否开启视频问诊
+(void)startViedoChat:(NSString *)url Parameters:(NSDictionary *)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSString *xtrId,NSNumber *serviceAmount,NSNumber *isFree,NSNumber *code))complation  Fail:(void(^)(NSError *error))fail;



//发布病例有图
+(void)CasePicWithURLString:(NSString *)url heads:(NSDictionary *)heads Parameters:(NSArray *)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSDictionary *dicCom))complation Fail:(void(^)(NSError *error))fail;

//Post
+(void)postWithURLStringALL:(NSString *)url
                         heads:(NSDictionary *)heads
                    parameters:(id)parameters
                 viewConroller:(UIViewController *)vc
                       success:(void(^)(id responseObject, BOOL ifTimeout))success
                       failure:(void(^)(NSError *error))failure;
//Get
+(void)getWithURLStringALL:(NSString *)url
                     heads:(NSDictionary *)heads
                parameters:(id)parameters
             viewConroller:(UIViewController *)vc
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;
@end

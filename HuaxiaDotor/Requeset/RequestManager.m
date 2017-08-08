//
//  RequestManager.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/21.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "RequestManager.h"
#import "PatientModel.h"
#import "PatientDetailModel.h"
#import "AddMocel.h"
#import "HillFreeModel.h"
#import "WebClinicModel.h"
#import "CaseModel.h"
#import "OnLineViedo.h"
#import "DoctorAdviceModel.h"
#import "DocAdviceDetailModel.h"
#import "GroupModel.h"
#import "GroupDetailModel.h"
#import "Anasisy.h"
@implementation RequestManager

/**
 *  POST 请求
 *
 *  @param url        请求地址
 *  @param parameters 参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+(void)postWithURLString:(NSString *)url
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

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
                 failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSArray *headsKey = [heads allKeys];
    for(NSInteger i=0;i<headsKey.count;i++)
    {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[[heads objectForKey:headKeyString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:headKeyString];
    }
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSNumber *code=[dic objectForKey:RESPONSE_KEY_CODE];
        if ([code integerValue]==RESPONSE_CODE_SUCCESS)
        {
            if(success)
            {
                success([dic objectForKey:RESPONSE_KEY_VALUE]);
            }
        }
        else if ([code integerValue]==RESPONSE_CODE_FAILURE)
        {
            [showAlertView showAlertViewWithMessage:[dic objectForKey:RESPONSE_KEY_MESSAGE]];
        }
        else if ([code integerValue]==RESPONSE_CODE_TIMEOUT)
            if([dic objectForKey:RESPONSE_KEY_MESSAGE])
            {
                [showAlertView showAlertViewWithMessage:[dic objectForKey:RESPONSE_KEY_MESSAGE]];
                //如果超时变退出登录
                [PublicTools moveTologinPage];
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+(void)getWithURLString:(NSString *)url
                  heads:(NSDictionary *)heads
             parameters:(id)parameters
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.securityPolicy = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSArray *headsKey = [heads allKeys];
    for(NSInteger i=0;i<headsKey.count;i++)
    {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[heads objectForKey:headKeyString] forHTTPHeaderField:headKeyString];
    }
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == -10004) {
            kLoginTimeOut;
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark ------ 医生获得患者列表
+(void)getTextOrderListURL:(NSString *)url heads:(NSDictionary *)heads parameters:(id)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSMutableArray *arry))complation Fail:(void(^)(NSError *error))fail{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.securityPolicy = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSArray *headsKey = [heads allKeys];
    for(NSInteger i=0;i<headsKey.count;i++)
    {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[heads objectForKey:headKeyString] forHTTPHeaderField:headKeyString];
    }
    
    MBProgressHUD *HUD = [RequestManager getHUD:vc];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD.hidden = YES;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        NSMutableArray *arryData = [[NSMutableArray alloc]init];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == -10004) {
            kLoginTimeOut;
        }

        NSArray *arry= [responseObject objectForKey:@"value"];
        for (NSDictionary *dicValue in arry) {
            PatientModel *patient = [[PatientModel alloc]init];
            NSArray*arryKey = [dicValue allKeys];
            for (NSString *key in arryKey) {
                [patient setValue:[dicValue objectForKey:key] forKey:key];
            }
            [arryData addObject:patient];
        }
        complation(arryData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD.hidden = YES;
        fail(error);
    }];
}

#pragma mark ------ 判断是否开启视频问诊
+(void)startViedoChat:(NSString *)url Parameters:(NSDictionary *)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSString *xtrId,NSNumber *serviceAmount,NSNumber *isFree,NSNumber *code))complation Fail:(void(^)(NSError *error))fail{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[kUserDefatuel objectForKey:@"verifyCode"] forHTTPHeaderField:@"verifyCode"];
    
    MBProgressHUD *HUD = [RequestManager getHUD:vc];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD.hidden = YES;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == -10004) {
            kLoginTimeOut;
        }

        if ([[dic objectForKey:@"value"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dicvalue = [dic objectForKey:@"value"];
            NSString *str = [dicvalue objectForKey:@"xtrId"];
            NSInteger count = [[dicvalue objectForKey:@"serviceAmount"] integerValue];
            NSInteger isFree = [[dicvalue objectForKey:@"isFree"] integerValue];
            complation(str,@(count),@(isFree),nil);
            
        }else
        {
            NSInteger code = [[dic objectForKey:@"value"] integerValue];
            complation(nil,nil,nil,@(code));
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD.hidden = YES;
        fail(error);
    }];
    
}

#pragma mark ------发布病例有图
+(void)CasePicWithURLString:(NSString *)url heads:(NSDictionary *)heads Parameters:(NSArray *)parameters viewConroller:(UIViewController *)vc Complation:(void(^)(NSDictionary *dicCom))complation Fail:(void(^)(NSError *error))fail{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    NSArray *headsKey = [heads allKeys];
    for(NSInteger i=0;i<headsKey.count;i++)
    {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[heads objectForKey:headKeyString] forHTTPHeaderField:headKeyString];
    }
    
    MBProgressHUD *HUD = [RequestManager getHUD:vc];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSInteger i = 0; i<parameters.count ; i++ ) {
            NSData *data = parameters[i];
            [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%ld.png",i] mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD.hidden = YES;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //判断类型
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == -10004) {
            kLoginTimeOut;
        }
        complation(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD.hidden = YES;
        fail(error);
    }];
}


#pragma mark ------Post
+(void)postWithURLStringALL:(NSString *)url
                         heads:(NSDictionary *)heads
                    parameters:(id)parameters
                 viewConroller:(UIViewController *)vc
                       success:(void(^)(id responseObject, BOOL ifTimeout))success
                       failure:(void(^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSArray *headsKey = [heads allKeys];
    for (NSInteger i = 0; i<headsKey.count; i++) {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[heads objectForKey:headKeyString] forHTTPHeaderField:headKeyString];
    }
    
    MBProgressHUD *HUD = [RequestManager getHUD:vc];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD.hidden = YES;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSNumber *code = [dic objectForKey:@"code"];
            if ([code integerValue] == RESPONSE_CODE_SUCCESS){
                if (success) {
                    success([dic objectForKey:@"value"],NO);
                }
            }else{
                if ([code integerValue] == RESPONSE_CODE_FAILURE){
                    
                }else if ([code integerValue] == RESPONSE_CODE_TIMEOUT) {
                    kLoginTimeOut;
                }

                if ([dic objectForKey:@"message"]) {
                    KMESSAGEWRONG([dic objectForKey:@"message"]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD.hidden = YES;
        if (error) {
            failure(error);
            kReuestFaile;
        }
    }];
}
#pragma mark ------Get
+(void)getWithURLStringALL:(NSString *)url
                     heads:(NSDictionary *)heads
                parameters:(id)parameters
             viewConroller:(UIViewController *)vc
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.securityPolicy = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSArray *headsKey = [heads allKeys];
    for(NSInteger i=0;i<headsKey.count;i++)
    {
        NSString *headKeyString = [headsKey objectAtIndex:i];
        [manager.requestSerializer setValue:[heads objectForKey:headKeyString] forHTTPHeaderField:headKeyString];
    }

    MBProgressHUD *HUD = [RequestManager getHUD:vc];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD.hidden = YES;

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSNumber *code = [dic objectForKey:@"code"];
            if ([code integerValue] == RESPONSE_CODE_SUCCESS){
                if (success) {
                    success([dic objectForKey:@"value"]);
                }
            }else{
                if ([code integerValue] == RESPONSE_CODE_FAILURE){
                    
                }else if ([code integerValue] == RESPONSE_CODE_TIMEOUT) {
                    kLoginTimeOut;

                }

                if ([dic objectForKey:@"message"]) {
                    KMESSAGEWRONG([dic objectForKey:@"message"]);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD.hidden = YES;
        if (error) {
            failure(error);
            kReuestFaile;
        }
    }];
}

+(MBProgressHUD *)getHUD:(UIViewController *)vc{
    MBProgressHUD *HUD;
    NSDictionary *dic = [PublicTools isContantHUD:vc];
    if ([dic[@"hud"] isKindOfClass:[MBProgressHUD class]]) {
        HUD = (MBProgressHUD *)dic[@"hud"];
    }else
    {
        HUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    }
    return HUD;
}

+ (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"yanketong" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    //    securityPolicy.validatesDomainName = YES;
//    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
//    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

@end

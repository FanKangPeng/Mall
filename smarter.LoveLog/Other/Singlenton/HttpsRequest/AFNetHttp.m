//
//  AFNetHttp.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/24.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "AFNetHttp.h"
#import "AppDelegate.h"
#import "MyKeyChainHelper.h"
#import "NSDictionary+FanExtension.h"
#define ContentType @"text/html"

@implementation AFNetHttp





+(AFNetHttp *) sharedInstance{
    
    static AFNetHttp *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
        
    });
    
    return sharedInstace;
}

+(void)getData:(NSString *)url params:(NSDictionary *)params session:(BOOL)session success:(void (^)(NSDictionary *))success failure:(void (^)(id))failure
{
    url =[LoveLog_Host stringByAppendingString:url];

    //  添加session    全局添加    所以session为在这里设置为了yes  以后需要改  去掉这里的设置 在外面接口位置设置session的值
    NSDictionary * sessionDictionary =[NSDictionary dictionaryWithDictionary:[MyKeyChainHelper getSession:KeyChain_SessionKey]];
    if (sessionDictionary.allKeys.count>0) {
        NSDictionary  * sessionDict =@{@"uid":[sessionDictionary objectForKey:@"uid"],@"sid":[sessionDictionary objectForKey:@"sid"]};
        NSDictionary * sessionDict1 = @{@"session":sessionDict};
        NSMutableDictionary * ddd = [NSMutableDictionary dictionaryWithDictionary:sessionDict1];
        [ddd addEntriesFromDictionary:params];
        params  = [NSDictionary dictionaryWithDictionary:ddd];
    }
  
    
    //判断网络
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"似乎与互联网断开了连接"forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:@"customError" code:-1000 userInfo:userInfo];
    
    AppDelegate * app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    if(app.status == ConnectionStatus_NETWORK_UNAVAILABLE)
        failure(aError);
    [self requestWihtMethod:RequestMethodTypePost url:url params:params success:^(id response) {
        NSNumber * successed =[[response objectForKey:@"status"] objectForKey:@"succeed"];
        if([successed isEqualToNumber:[NSNumber numberWithLong:1]])
        {
            if ([response objectForKey:@"data"]) {
                NSArray * array =[response objectForKey:@"data"];
                if (array.count>0) {
                    success(response);
                }
                else
                {
                    NSDictionary *nodata = [NSDictionary dictionaryWithObject:@"暂无数据"forKey:NSLocalizedDescriptionKey];
                    NSError *nodataError = [NSError errorWithDomain:@"customError" code:-1000 userInfo:nodata];
                    failure(nodataError);
                }
            }
            else
            {
                success(response);
            }
        }
        else
            failure([response objectForKey:@"status"]);
    } failure:^(NSError *err) {
        failure(err);
    }];

}  

+ (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
        //获得请求管理者
        
        AFHTTPSessionManager * mgr =[AFHTTPSessionManager manager];
    //设置超时时间
        [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        mgr.requestSerializer.timeoutInterval = 10.0f;
        [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
   
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];

#ifdef ContentType
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
//        mgr.requestSerializer.HTTPShouldHandleCookies = YES;
//      
//        
//        NSString *cookieString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"];
//        
//        if(cookieString)
//            [mgr.requestSerializer setValue: cookieString forHTTPHeaderField:@"Cookie"];
    
        switch (methodType) {
            case RequestMethodTypeGet:
            {
                //GET请求
                [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                    //
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        NSError * err ;
                        NSDictionary * dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                        success([NSDictionary changeType:dict]);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            }
                break;
            case RequestMethodTypePost:
            {
                
                //POST请求
                [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    //
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    //
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        NSError * err ;
                        NSDictionary * dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

                        if(err)
                        {
                            FLog(@"responseObjectData === %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                            NSLog(@"json解析失败：%@",err);
                            failure(err);
                        }
                        else
                            success([NSDictionary changeType:dict]);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure(error);
                    }
                }];
                
                
            }
                break;
            default:
                break;
        }
    
}

#pragma mark - setter
- (NSDictionary *)sessionDict
{
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:[MyKeyChainHelper getSession:KeyChain_SessionKey]];
   
    return dict;
}


@end

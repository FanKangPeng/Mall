//
//  AFNetHttp.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/24.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

@interface AFNetHttp : NSObject
/**
 单例
 */
+(AFNetHttp*)sharedInstance;
/**
 *  session
 */
@property (nonatomic ,strong) NSDictionary * sessionDict;

/**
 *  发送一个请求
 *
 *  @param methodType   请求方法
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void) requestWihtMethod:(RequestMethodType)
methodType url : (NSString *)url
                   params:(NSDictionary *)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

/**
 获取数据添加请求头
 */
+(void)getData:(NSString*)url params:(NSDictionary *)params session:(BOOL)session success:(void (^)(NSDictionary* response))success failure:(void (^)(id error))failure;




@end

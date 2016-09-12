//
//  LoginInfo.h
//  RongCloud
//  登陆信息
//  Created by Liv on 14/11/10.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RCDLoginInfo : NSObject

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic, copy)NSString *portrait;

+(id) shareLoginInfo;

/**
 *从服务器获取融云帐号和密码
 */
-(void)getUserData;
/**
 *登录融云服务器
 */
-(void)LoginRongCloudWithUserName:(NSString*)username andPassword:(NSString*)password;
/**
 *聊天登录
 */
-(void)ChatLogin;
/**
 *聊天注册
 */
-(void)ChatRegisterWithDict:(NSDictionary*)dict;
/**
 *退出登录
 */
-(void)ChatTuichu;
/**
 融云登录
 */
+(void) loginWithEmail:(NSString *) email
              password:(NSString *) password
                   env:(int) env
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure;
/**
 融云注册 发送email  mobile username password 信息
 */
+(void) registerWithEmail:(NSString *) email
                   mobile:(NSString *) mobile
                 userName:(NSString *) userName
                 password:(NSString *) password
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;
/**
 融云获取token
 */
+(void) getTokenSuccess:(void (^)(id response))success
                failure:(void (^)(NSError* err))failure;
@end

//
//  LoginInfo.m
//  RongCloud
//
//  Created by Liv on 14/11/10.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDLoginInfo.h"
#import <RongIMKit/RongIMKit.h>
#import "AFNetHttp.h"

@implementation RCDLoginInfo

+(id)shareLoginInfo
{
    static RCDLoginInfo *loginInfo = nil;
    static dispatch_once_t  predicate;
    dispatch_once(&predicate,^{
        loginInfo = [[self alloc] init];
    });

    return loginInfo;
}

-(void)ChatRegisterWithDict:(NSDictionary *)dict
{
    NSDictionary *params = @{@"email":@"",
                             @"mobile":@"",
                             @"username":[dict objectForKey:@"username"],
                             @"password":[dict objectForKey:@"password"]};
    [AFNetHttp requestWihtMethod:RequestMethodTypePost url:@"reg" params:params success:^(id response) {
        
    } failure:^(NSError *err) {
        
    }];
}
-(void)ChatTuichu
{
    
}
-(void)ChatLogin
{
    [self getUserData];
}
-(void)getUserData
{
    NSString * username =[[NSUserDefaults standardUserDefaults] objectForKey:@"RCDUsername"];
    NSString * password =[[NSUserDefaults standardUserDefaults] objectForKey:@"RCDPassword"];
    if(username.length<=0)
    {
        //去服务器请求  得到后 登录融云
        [[NSUserDefaults standardUserDefaults] setObject:@"fkplyy02@163.com" forKey:@"RCDUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:@"15936219505" forKey:@"RCDPassword"];
        username =[[NSUserDefaults standardUserDefaults] objectForKey:@"RCDUsername"];
        password =[[NSUserDefaults standardUserDefaults] objectForKey:@"RCDPassword"];
        [self LoginRongCloudWithUserName:username andPassword:password];
    }
    else
    {
        [self LoginRongCloudWithUserName:username andPassword:password];
    }
}
-(void)LoginRongCloudWithUserName:(NSString *)username andPassword:(NSString *)password
{
 //   NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString * token =@"9L4ChBx08ESGiOWqF9Ean1X05byyZWBDGvnVp14RH7IKW7Z1Mdnmz7DQXJNYoO+VDfrkheVDOh8kbDyhsLlpuaApmJR38tIfp7tdDOKFO80=";
    if(token.length && username.length && password.length)
    {
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            //登录融云服务器成功
             [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"userToken"];
            [RCDLoginInfo  loginWithEmail:username password:password env:1 success:^(id response) {
                //登录成功
                RCDLoginInfo *loginInfo = [RCDLoginInfo  mj_objectWithKeyValues:response[@"result"]];
                [[NSUserDefaults standardUserDefaults] setObject:loginInfo.token forKey:@"userToken"];
                
            } failure:^(NSError *err) {
                //登录失败
            }];
        } error:^(RCConnectErrorCode status) {
            //
             NSLog(@"token不正确");
        } tokenIncorrect:^{
            //
             NSLog(@"token过期");
        }];
    }
    else
    {
        
        [AFNetHttp requestWihtMethod:RequestMethodTypePost url:[FAKE_SERVER stringByAppendingString:@"email_login_token"] params:@{@"email":username,@"password":password} success:^(id response) {
            //
             RCDLoginInfo *loginInfo = [RCDLoginInfo mj_objectWithKeyValues:response[@"result"]];
            [[NSUserDefaults standardUserDefaults] setObject:loginInfo.token forKey:@"userToken"];
            [[RCIM sharedRCIM] connectWithToken:loginInfo.token success:^(NSString *userId) {
                //登录融云服务器成功
                 [[NSUserDefaults standardUserDefaults] setObject:loginInfo.token forKey:@"userToken"];
            } error:^(RCConnectErrorCode status) {
                //
                 NSLog(@"token不正确");
            } tokenIncorrect:^{
                //
                NSLog(@"token过期");
            }];
        } failure:^(NSError *err) {
            //
        }];
    }
    
}
//rong_cloud login
+(void) loginWithEmail:(NSString *) email
              password:(NSString *) password
                   env:(int) env
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"email":email,@"password":password};
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey :@"UserCookies"];
    [AFNetHttp requestWihtMethod:RequestMethodTypePost
                             url:[FAKE_SERVER stringByAppendingString:@"email_login_token"]
                          params:params
                         success:success
                         failure:failure];
}

// rong_cloud reg email mobile username password
+(void) registerWithEmail:(NSString *) email
                   mobile:(NSString *) mobile
                 userName:(NSString *) userName
                 password:(NSString *) password
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    
    
    NSDictionary *params = @{@"email":email,
                             @"mobile":mobile,
                             @"username":userName,
                             @"password":password};
    [AFNetHttp requestWihtMethod:RequestMethodTypePost
                             url:[FAKE_SERVER stringByAppendingString:@"reg"]
                          params:params
                         success:success
                         failure:failure];
}

// rong_cloud get token
+(void) getTokenSuccess:(void (^)(id response))success
                failure:(void (^)(NSError* err))failure
{
    [AFNetHttp requestWihtMethod:RequestMethodTypeGet
                             url:[FAKE_SERVER stringByAppendingString:@"token"]
                          params:nil
                         success:success
                         failure:failure];
}
@end

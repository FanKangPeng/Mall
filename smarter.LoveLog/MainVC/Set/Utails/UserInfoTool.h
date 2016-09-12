//
//  UserInfoTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);
@interface UserInfoTool : NSObject
/**
 *登录
 */
+(void)Login:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *注册/找回密码/获取验证码/修改用户信息/获取我的钱包、红包、积分数据/提交反馈意见/订单操作（取消，确认收货）
 */
+(void)userInfo:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;

/**
 *通知 消息
 */
+(void)getMessage:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;

/**
 *订单
 */
+(void)getOrder:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *收藏
 */
+(void)getCollect:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *  使用红包
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+(void)userRedPacket:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *  获取红包数据
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+(void)getRedPacketData:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *  第三方登录
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+(void)pushThirdLoginData:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
@end

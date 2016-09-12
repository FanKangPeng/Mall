//
//  PayTools.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);
@interface PayTools : NSObject
/**
 *  支付
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+ (void)paywithUrl:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;

/**
 *  验证支付结果
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */

+ (void)paystatuswithUrl:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
@end

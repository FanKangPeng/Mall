//
//  OrderTools.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/27.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetHttp.h"

typedef void(^CallBack)(id obj);

@interface OrderTools : NSObject

/**
 *  获取结算订单信息
 */
+ (void)getOrerInfowithUrl:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *  获取收货人收货地址和配送方式以及运费
 *
 *  @param url       url
 *  @param params   地址ID
 */
+ (void)getConsigneeInfowithUrl:(NSString*)url params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *  积分兑换
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+ (void)ExchangeIntegralwithUrl:(NSString*)url params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *  提交订单信息
 *
 *  @param url     url
 *  @param params  params
 *  @param success success
 *  @param failure failure
 */
+ (void)pushOrderDatawithUrl:(NSString*)url params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
@end

//
//  AddressTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/14.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);
@interface AddressTool : NSObject
/**
 *获取收货地址
 */
+(void)getAddressList:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *设置默认地址
 */
+(void)setDefaultAddress:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *删除
 */
+(void)deleteAddress:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *添加地址
 */
+(void)addAddress:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
/**
 *获取省市区
 */
+(void)getallAddress:(NSString*)url  params:(NSDictionary*)params success:(CallBack)success failure:(CallBack)failure;
@end

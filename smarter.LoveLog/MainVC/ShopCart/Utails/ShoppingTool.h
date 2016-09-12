//
//  ShoppingTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);
@interface ShoppingTool : NSObject

/**
 *获取购物车数据
 */
+(void)getShoppingCartData:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;

/**
 * 购物车操作 删除 添加 更新
 */
+(void)ShoppingCartOperate:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
@end

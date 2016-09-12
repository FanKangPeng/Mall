//
//  FMDBManager.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "GoodsTool.h"
#import "ShoppingModel.h"
@interface FMDBManager : NSObject

/**
 *  查询数量
 *
 *  @return 返回具体的数量
 */
+ (int)selectCount;

/**
 *  查询数据库  返回所有的数据
 */
+ (NSArray*)selectCart;

/**
 *  添加 参数为一条购物车数据
 */
+ (void)addCart:(ShoppingModel*)model;
/**
 *  删除
 */
+ (void)delectCart:(ShoppingModel*)model;
/**
 *  更新 
 */
+ (void)updataCart:(ShoppingModel*)model;

/**
 * 提交本地的购物车数据到服务器
 */
+ (void)postData;
@end

//
//  ExpressageModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/27.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressageModel : NSObject

/**
 *  配送方式名称
 */
@property (nonatomic ,copy) NSString *shipping_name;
/**
 *描述
 */
@property (nonatomic ,copy) NSString *shipping_desc;
/**
 *  运费
 */
@property (nonatomic ,copy) NSString *shipping_fee;
/**
 *  id
 */
@property (nonatomic ,copy) NSString *shipping_id;
/**
 *  format_shipping_fee
 */
@property (nonatomic ,copy) NSString *format_shipping_fee;
/**
 *  满包邮费用
 */
@property (nonatomic ,copy) NSString *free_money;
/**
 *  shipping_code
 */
@property (nonatomic ,copy) NSString *shipping_code;

@end

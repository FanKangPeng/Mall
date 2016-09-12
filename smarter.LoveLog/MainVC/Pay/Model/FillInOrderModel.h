//
//  FillInOrderModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/27.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressModel.h"


@interface FillInOrderModel : NSObject
/**
 *  支付方式list
 */
@property (nonatomic ,strong) NSArray *paymentList;
/**
 *  配送方式list
 */
@property (nonatomic ,strong) NSArray *expressList;
/**
 *  产品
 */
@property (nonatomic ,strong) NSArray *shopArr;
/**
 * 发票信息1
 */
@property (nonatomic ,strong) NSArray *inv_type_list;
/**
 *  发票信息2
 */
@property (nonatomic ,strong) NSArray *inv_content_list;
/**
 *  地址信息
 */
@property (nonatomic ,strong) AddressModel *addressModel;
/**
 *  用户积分
 */
@property (nonatomic ,copy) NSString *user_integral;
/**
 *  是否允许使用红包
 */
@property (nonatomic ,copy) NSString *allow_use_bonus;
/**
 *  红包
 */
@property (nonatomic ,strong) NSArray *bonus;
/**
 *  已用红包ID
 */
@property (nonatomic ,copy) NSString *default_bonus_id;
/**
 *  订单最大使用积分
 */
@property (nonatomic ,copy) NSString *order_max_integral;
/**
 *  总计信息
 */
@property (nonatomic ,strong) NSDictionary *total;
/**
 *  默认支付方式ID
 */
@property (nonatomic ,copy) NSString *default_pay_type_id;
/**
 *  默认支付方式名称
 */
@property (nonatomic ,copy) NSString *default_pay_type_name;
/**
 *  默认配送方式ID
 */
@property (nonatomic ,copy) NSString *default_shipping_id;
/**
 *  默认配送方式名称
 */
@property (nonatomic ,copy) NSString *default_shipping_name;
@end

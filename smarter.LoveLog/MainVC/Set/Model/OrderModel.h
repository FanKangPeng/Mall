//
//  OrderModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic ,strong) NSString * order_id;
@property (nonatomic ,strong) NSString * formated_integral_money;
@property (nonatomic ,strong) NSString * formated_shipping_fee;
@property (nonatomic ,strong) NSArray * formated_bonus;
@property (nonatomic ,strong) NSString * total_fee;
@property (nonatomic ,strong) NSDictionary * order_info;
@property (nonatomic ,strong) NSString * order_sn;
@property (nonatomic ,strong) NSString * order_time;
@property (nonatomic ,strong) NSArray * goods_list;
@end
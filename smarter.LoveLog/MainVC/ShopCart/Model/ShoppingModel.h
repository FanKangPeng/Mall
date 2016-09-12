//
//  ShoppingModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingModel : NSObject

/**
 *  商品在购物车中选择的状态
 */
@property(assign,nonatomic) BOOL selectState;//是否选中状态

/**
 *  商品名称
 */
@property (nonatomic ,copy) NSString *goods_name;
/**
 *  能否处理
 */
@property (nonatomic ,copy) NSString *can_handsel;
/**
 *  ???????
 */
@property (nonatomic ,copy) NSString *pid;
/**
 *  是否是赠品  0 否 ，其他，是参加优惠活动的ID
 */
@property (nonatomic ,copy) NSString *is_gift;
/**
 *  该商品的父商品ID ，没有该值为0 有的话该商品就是该ID的配件
 */
@property (nonatomic ,copy) NSString *parent_id;
/**
 *  商品个数
 */
@property (nonatomic ,copy) NSString *goods_number;
/**
 *  是否免邮  0 不免邮费  1免邮费
 */
@property (nonatomic ,copy) NSString *is_shipping;
/**
 *  商品小图
 */
@property (nonatomic ,copy) NSString *img_thumb;
/**
 *  商品编码
 */
@property (nonatomic ,copy) NSString *goods_sn;
/**
 *  总价
 */
@property (nonatomic ,copy) NSString *subtotal;
/**
 *  商场价格
 */
@property (nonatomic ,copy) NSString *market_price;
/**
 *  是否为实物  1是 0否：比如虚拟卡为0 不是实物
 */
@property (nonatomic ,copy) NSString *is_real;
/**
 *  商品ID
 */
@property (nonatomic ,copy) NSString *goods_id;
/**
 *  属性ID
 */
@property (nonatomic ,copy) NSString *goods_attr_id;
/**
 *  商品单价
 */
@property (nonatomic ,copy) NSString *goods_price;
/**
 *  商品属性
 */
@property (nonatomic ,copy) NSString *goods_attr;
/**
 *  商品类型
 */
@property (nonatomic ,copy) NSString *rec_type;
/**
 *  购物车唯一ID
 */
@property (nonatomic ,copy) NSString *rec_id;
/**
 *  虚拟产品扩展码
 */
@property (nonatomic ,copy) NSString *extension_code;


/**
 *  提供一个方法 创建ShoppingModel
 *
 *  @param shopID      购物车ID
 *  @param imageName   购物车商品图片URL
 *  @param goodsTitle  商品名称
 *  @param goodsType   商品type
 *  @param goodsPrice  商品价格
 *  @param selectState 商品在购物车中选择的状态
 *  @param goodsNum    商品数量
 *
 *  @return ShoppingModel
 */
+ (ShoppingModel*)createModelByShopID:(NSString*)shopID imageName:(NSString*)imageName goodsTitle:(NSString*)goodsTitle goodsType:(NSString*)goodsType goodsPrice:(NSString*)goodsPrice selectState:(BOOL)selectState goodsNum:(NSString *)goodsNum isshopping:(NSString*)ishopping isgift:(NSString *)isgift;

@end

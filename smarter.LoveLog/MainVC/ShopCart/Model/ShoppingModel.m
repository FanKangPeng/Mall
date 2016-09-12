//
//  ShoppingModel.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ShoppingModel.h"

@implementation ShoppingModel

+ (ShoppingModel *)createModelByShopID:(NSString *)shopID imageName:(NSString *)imageName goodsTitle:(NSString *)goodsTitle goodsType:(NSString *)goodsType goodsPrice:(NSString *)goodsPrice selectState:(BOOL)selectState goodsNum:(NSString *)goodsNum isshopping:(NSString*)ishopping isgift:(NSString *)isgift
{
    ShoppingModel * MODEL = [[ShoppingModel alloc] init];
    MODEL.rec_id = shopID;
    MODEL.img_thumb = imageName;
    MODEL.goods_name = goodsTitle ;
    MODEL.rec_type = goodsType ;
    MODEL.goods_price = goodsPrice;
    MODEL.selectState  = selectState;
    MODEL.goods_number = goodsNum;
    MODEL.is_gift = isgift;
    MODEL.is_shipping = ishopping;
    return MODEL;
}

@end

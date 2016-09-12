//
//  GoodModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject
@property(nonatomic,copy)NSString * is_shipping;
@property(nonatomic,copy)NSString * is_collect;
@property(nonatomic,copy)NSString * click_count;
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,strong)NSDictionary * img;
@property(nonatomic,copy)NSString * goods_name;
@property(nonatomic,copy)NSString * shop_price;
@property(nonatomic,copy)NSString * cat_id;
@property(nonatomic,copy)NSString * collect_count;
@property(nonatomic,copy)NSString * brand_id;
@property(nonatomic,copy)NSString * is_like;
@property(nonatomic,strong)NSArray * rank_price;
@property(nonatomic,copy)NSString * goods_brief;
@property(nonatomic,copy)NSString * id;
@property(nonatomic,strong)NSArray * properties;
@property(nonatomic,strong)NSArray * cmt;
@property(nonatomic,strong)NSArray * specification;
@property(nonatomic,strong)NSArray * promote;
@property(nonatomic,copy)NSString * goods_number;
@property(nonatomic,strong)NSArray * pictures;
@property(nonatomic,copy)NSString * goods_weight;
@property(nonatomic,copy)NSString * goods_sn;
@property(nonatomic,copy)NSString * intergral;
@property(nonatomic,copy)NSString *like_count;
@property(nonatomic,copy)NSString *bought_count;
@property(nonatomic,copy)NSString *cmt_count;
@end

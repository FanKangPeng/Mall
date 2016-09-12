//
//  ShoppingTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "ShoppingTool.h"
#import "AFNetHttp.h"
#import "ShoppingModel.h"
@implementation ShoppingTool
+(void)getShoppingCartData:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        
        [weakSelf jsonAnalysWithJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];

}
+(void)ShoppingCartOperate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary*
                                                               response) {
        
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];

}
//解析
+(void)jsonAnalysWithJson:(id)json Callback:(CallBack)callBack
{
    NSMutableArray * shopArr = [NSMutableArray array];
    NSDictionary * dict = [json objectForKey:@"data"];
    NSArray * goods_list = [dict objectForKey:@"goods_list"];
    for (NSDictionary * shopDict in goods_list) {
        ShoppingModel * model = [[ShoppingModel  alloc] init];
        model.goods_name = [shopDict objectForKey:@"goods_name"];
        model.selectState = YES;
        model.can_handsel = [shopDict objectForKey:@"can_handsel"];
        model.pid = [shopDict objectForKey:@"pid"];
        model.parent_id = [shopDict objectForKey:@"parent_id"];
        model.goods_number = [shopDict objectForKey:@"goods_number"];
        model.is_shipping = [shopDict objectForKey:@"is_shipping"];
        model.img_thumb = [shopDict objectForKey:@"img_thumb"];
        model.goods_sn = [shopDict objectForKey:@"goods_sn"];
        model.subtotal = [shopDict objectForKey:@"subtotal"];
        model.market_price = [shopDict objectForKey:@"market_price"];
        model.extension_code = [shopDict objectForKey:@"extension_code"];
        model.is_real = [shopDict objectForKey:@"is_real"];
        model.goods_id = [shopDict objectForKey:@"goods_id"];
        model.goods_price = [shopDict objectForKey:@"goods_price"];
        model.goods_attr = [shopDict objectForKey:@"goods_attr"];
        model.rec_type = [shopDict objectForKey:@"rec_type"];
        model.goods_attr_id = [shopDict objectForKey:@"goods_attr_id"];
        model.rec_id = [shopDict objectForKey:@"rec_id"];
        model.is_gift =  [shopDict objectForKey:@"is_gift"];
        
        [shopArr addObject:model];
    }
    callBack(shopArr);
    
}
@end

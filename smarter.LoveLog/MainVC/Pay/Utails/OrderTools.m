//
//  OrderTools.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/27.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "OrderTools.h"
#import "AddressModel.h"
#import "PaymentMethod.h"
#import "ExpressageModel.h"
#import "FillInOrderModel.h"
#import "ShoppingModel.h"
#import "RedPacketModel.h"
@implementation OrderTools
+ (void)pushOrderDatawithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        success(response);
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)ExchangeIntegralwithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        success(response);
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)getConsigneeInfowithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        NSDictionary * json = [response objectForKey:@"data"];
        
        AddressModel * model = [AddressModel mj_objectWithKeyValues:[json objectForKey:@"consignee"]];
        NSArray * list = [json objectForKey:@"shipping_list"];
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dict  in list) {
            ExpressageModel * expressmodel = [ExpressageModel mj_objectWithKeyValues:dict];
            [arr addObject:expressmodel];
        }
        NSDictionary * data  = @{@"consignee":model,@"shipping_list":arr};
        success(data);
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)getOrerInfowithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        [self jsonDataToMdeol:response callBack:success];
    } failure:^(id error) {
        failure(error);
    }];
}

+ (void)jsonDataToMdeol:(NSDictionary *)response callBack:(CallBack)callBack
{
    FLog(@"orderData = %@",response);
    FillInOrderModel * model = [[FillInOrderModel alloc] init];
    NSMutableArray * payMentList = [NSMutableArray array];
    NSMutableArray * expressageList = [NSMutableArray array];
      NSMutableArray * goodsList = [NSMutableArray array];
    NSDictionary * jsonDict = [response objectForKey:@"data"];
    NSArray * payMent_list = [jsonDict objectForKey:@"payment_type"];
    for (NSDictionary * payMent in payMent_list) {
        PaymentMethod * paymentMethod = [PaymentMethod mj_objectWithKeyValues:payMent];
        [payMentList addObject:paymentMethod];
    }
    model.paymentList = payMentList;
   
    NSDictionary *addressDict = [jsonDict objectForKey:@"consignee"];

    AddressModel * addressModel = [[AddressModel alloc] init];
    if([addressDict isKindOfClass:[NSDictionary class]])
    {
        addressModel.address = [addressDict objectForKey:@"address"];
        addressModel.is_default =[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"is_default"]];
        addressModel.id = [addressDict objectForKey:@"address_id"];
        addressModel.consignee = [addressDict objectForKey:@"consignee"];
        addressModel.mobile = [addressDict objectForKey:@"mobile"];
        addressModel.country_name = [addressDict objectForKey:@"country_name"];
        addressModel.province_name = [addressDict objectForKey:@"province_name"];
        addressModel.district_name = [addressDict objectForKey:@"district_name"];
        addressModel.city_name = [addressDict objectForKey:@"city_name"];
    }
    model.addressModel = addressModel;

    NSArray *express = [jsonDict objectForKey:@"shipping_list"];
    for (NSDictionary *expressDict in express) {
        ExpressageModel * expressModel = [ExpressageModel mj_objectWithKeyValues:expressDict];
        [expressageList addObject:expressModel];
    }
    model.expressList = expressageList;
    
    model.inv_type_list = [jsonDict objectForKey:@"inv_type_list"];
    model.inv_content_list = [jsonDict objectForKey:@"inv_content_list"];
    model.user_integral = [jsonDict objectForKey:@"user_integral"];
    model.allow_use_bonus = [jsonDict objectForKey:@"allow_use_bonus"];
    model.order_max_integral = [jsonDict objectForKey:@"order_max_integral"];
    model.total = [jsonDict objectForKey:@"total"];
    NSArray *good_list = [jsonDict objectForKey:@"goods_list"];
    for (NSDictionary *good in good_list) {
        ShoppingModel *shoppingmodel = [ShoppingModel mj_objectWithKeyValues:good];
        [goodsList  addObject:shoppingmodel];
    }
    model.shopArr = goodsList;
    model.default_pay_type_id = [jsonDict objectForKey:@"default_pay_type_id"];
    model.default_pay_type_name = [jsonDict objectForKey:@"default_pay_type_name"];
    model.default_shipping_id = [jsonDict objectForKey:@"default_shipping_id"];
    model.default_shipping_name = [jsonDict objectForKey:@"default_shipping_name"];
    NSMutableArray * bonusArr = [NSMutableArray array];
    for (NSDictionary * reddict in [jsonDict objectForKey:@"bonus_list"]) {
        RedPacketModel *redMoDEL = [RedPacketModel mj_objectWithKeyValues:reddict];
        [bonusArr addObject:redMoDEL];
    }
    model.bonus = bonusArr;
    model.default_bonus_id =[jsonDict objectForKey:@"default_bonus_id"]  ;
    callBack(model);
}
@end

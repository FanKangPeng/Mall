//
//  AddressTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/14.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AddressTool.h"
#import "AFNetHttp.h"
#import "AddressModel.h"
#import "ProvinceModel.h"
@implementation AddressTool
+(void)getallAddress:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        [weakSelf jsonAnalysWithAllAddressJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)addAddress:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        success([response objectForKey:@"data"]);
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)deleteAddress:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        success([response objectForKey:@"data"]);
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)setDefaultAddress:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        success([response objectForKey:@"data"]);
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getAddressList:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(id response) {
       
        [weakSelf jsonAnalysWithAddressJson:response Callback:success];
      
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)jsonAnalysWithAddressJson:(id)json Callback:(CallBack)callback
{
    NSMutableArray * addressList =[NSMutableArray array];
    NSArray * addressi =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in addressi) {
        AddressModel * addressModel =[AddressModel mj_objectWithKeyValues:dictionary];
        [addressList addObject:addressModel];
    }
    callback(addressList);
    
}
+(void)jsonAnalysWithAllAddressJson:(id)json Callback:(CallBack)callback
{
    NSMutableArray * provinceArray  =[NSMutableArray array];
    NSDictionary * dict =[json objectForKey:@"data"];
    NSArray * province = [dict objectForKey:@"province"];
    for (NSDictionary * provinceDict in province) {
           ProvinceModel * provinceModel = [ProvinceModel mj_objectWithKeyValues:provinceDict];
            [provinceArray addObject:provinceModel];
    }
    callback(provinceArray);
}
@end

//
//  AddressModel.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
+ (AddressModel *)initAddressWithDict:(NSDictionary *)dict
{
    AddressModel * model = [[AddressModel alloc] init];
    model.id = [dict objectForKey:@"id"];
    model.consignee = [dict objectForKey:@"consignee"];
    model.mobile = [dict objectForKey:@"mobile"];
    model.country_name = [dict objectForKey:@""];
    
    return model;
}
@end

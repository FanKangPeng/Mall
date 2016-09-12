//
//  AddressModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * is_default;
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * consignee;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * country_name;
@property (nonatomic,strong) NSString * district_name ;
@property (nonatomic,strong) NSString * province_name ;
@property (nonatomic,strong) NSString * city_name ;


+ (AddressModel*)initAddressWithDict:(NSDictionary *)dict;
@end

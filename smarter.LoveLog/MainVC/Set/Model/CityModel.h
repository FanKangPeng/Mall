//
//  CityModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/14.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property(nonatomic,copy)NSString * parent_id;
@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,strong)NSArray * district;
@end

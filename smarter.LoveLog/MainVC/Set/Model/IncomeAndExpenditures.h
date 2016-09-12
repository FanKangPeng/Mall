//
//  IncomeAndExpenditures.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeAndExpenditures : NSObject
@property(nonatomic,copy)NSString * log_id;
@property(nonatomic,copy)NSString * value;
@property(nonatomic,copy)NSString * change_time;
@property(nonatomic,copy)NSString * change_desc;
@property(nonatomic,copy)NSString * prefix;
@end

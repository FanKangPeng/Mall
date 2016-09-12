//
//  PaymentMethod.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/27.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethod : NSObject
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *sort_order;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *desc;


@end

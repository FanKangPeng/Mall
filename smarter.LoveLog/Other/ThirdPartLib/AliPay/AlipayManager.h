//
//  AlipayManager.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBlock)(id obj);
@interface AlipayManager : NSObject

@property (nonatomic ,copy)CallBlock WXPayBlock;
+ (void)startAliPay:(NSDictionary*)dict success:(CallBlock)success failure:(CallBlock)failure;
@end

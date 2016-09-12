//
//  WXApiManager.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApiObject.h>
#import <WXApi.h>

typedef void(^CallBlock)(id obj);
@interface WXApiManager : NSObject<WXApiDelegate>
@property (nonatomic ,copy)CallBlock WXPayBlock;

+ (instancetype)sharedManager;

+ (NSString *)jumpToBizPay;
+ (void)startWeChatPay:(NSDictionary*)dict callBlcok:(CallBlock)callBlock;
@end

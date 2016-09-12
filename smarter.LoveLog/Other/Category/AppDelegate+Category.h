//
//  AppDelegate+Category.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
@interface AppDelegate (Category)<RCIMConnectionStatusDelegate>
/**
 *初始化
 */
-(void)initAppdelegate;
/**
 *初始化分享 支付 平台
 */
-(void)initializeShareSDK;



@end

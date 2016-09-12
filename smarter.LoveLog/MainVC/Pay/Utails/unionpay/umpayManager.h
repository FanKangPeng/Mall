//
//  umpayManager.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPPaymentControl.h"

@interface umpayManager : NSObject

/**
 *  发起银联支付
 *
 *  @param tn             流水号
 *  @param schemeStr      商户自定义协议，商户在调用支付接口完成支付后，用于引导支付控件返回而定义的协议
 *  @param mode           接入模式，标识商户以何种方式调用支付控件，该参数提供以下两个可选值： "00"代表接入生产环境（正式版本需要）；"01"代表接入开发测试环境（测试版本需要）
 *  @param viewController 发起调用的视图控制器，商户应用程序调用银联手机支付控件的视图控制器；
 */
+ (void)startPayWithTn:(NSString *)tn schemeStr:(NSString *)schemeStr model:(NSString *)mode viewController:(UIViewController *)viewController;

@end

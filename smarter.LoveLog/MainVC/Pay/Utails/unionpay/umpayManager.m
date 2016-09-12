//
//  umpayManager.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "umpayManager.h"


#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"
#import "PayTools.h"

@implementation umpayManager

+ (void)startPayWithTn:(NSString *)tn schemeStr:(NSString *)schemeStr model:(NSString *)mode viewController:(UIViewController *)viewController
{
    
     [[UPPaymentControl defaultControl] startPay:tn fromScheme:schemeStr mode:mode viewController:viewController];
}

@end

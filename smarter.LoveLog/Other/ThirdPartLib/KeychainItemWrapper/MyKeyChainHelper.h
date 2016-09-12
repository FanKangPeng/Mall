//
//  MyKeyChainHelper.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeyChainHelper : NSObject
/**存储session*/
+ (void) saveSession :(NSDictionary*) session andSessionService :(NSString *)sessionService;
/**读取session*/
+ (NSDictionary*) getSession :(NSString *) sessionService;
/**删除session*/
+ (void) deleteSession :(NSString *) sessionService;


@end

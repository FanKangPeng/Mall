//
//  HomeDataTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/8.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);

@interface HomeDataTool : NSObject

+(void)getHomeDataWithUrl:(NSString*)url success:(CallBack)success  failure:(CallBack)failure;

+(void)getsomeThing:(NSString*)url success:(CallBack)success  failure:(CallBack)failure;
@end

//
//  GoodsTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);

@interface GoodsTool : NSObject

+(void)getgoodDetail:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success  failure:(CallBack)failure;
+(void)getComment:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure;
+(void)getCommentMoreDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure;
+(void)postData:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure;
@end

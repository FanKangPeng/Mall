//
//  PayTools.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "PayTools.h"
#import "AFNetHttp.h"
@implementation PayTools
+ (void)paystatuswithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)paywithUrl:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
}
@end

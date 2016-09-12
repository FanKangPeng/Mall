//
//  UserInfoModel.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/29.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+(UserInfoModel *) sharedInstance{
    
    static UserInfoModel *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        sharedInstace =[[self alloc]init];
    });
    return sharedInstace;
}
@end

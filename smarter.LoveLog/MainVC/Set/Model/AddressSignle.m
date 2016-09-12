//
//  AddressSignle.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/14.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AddressSignle.h"

@implementation AddressSignle
+(AddressSignle *) sharedInstance{
    
    static AddressSignle *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}
@end

//
//  IVar.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/24.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "IVar.h"

@implementation IVar
+ (void)ivarsdfsd
{
    unsigned int number = 0;
    Ivar * ivars  =class_copyIvarList([self class], &number);
    for (int i = 0; i <number; i ++) {
        Ivar this = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(this)];
    }
}
@end

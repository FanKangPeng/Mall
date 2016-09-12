//
//  UIWindow+Category.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "UIWindow+Category.h"
#import "LaunchViewController.h"

@implementation UIWindow (Category)


-(void)showLanuchPage
{
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    [self addSubview:launchVC.view];
}

@end

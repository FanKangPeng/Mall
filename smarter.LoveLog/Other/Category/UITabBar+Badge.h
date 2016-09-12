//
//  UITabBar+Badge.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)
- (void)showBadgeOnItemIndex:(int)index badgeValue:(NSUInteger)badgeValue;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end

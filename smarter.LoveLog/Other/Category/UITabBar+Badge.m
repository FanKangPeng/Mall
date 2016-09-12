//
//  UITabBar+Badge.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 4.0
@implementation UITabBar (Badge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index badgeValue:(NSUInteger)badgeValue{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.tag = 888 + index;
    badgeView.textAlignment = NSTextAlignmentCenter;
    if (badgeValue > 99) {
         badgeView.text = [NSString stringWithFormat:@"%d+",99];
    }
    else
       badgeView.text = [NSString stringWithFormat:@"%lu",(unsigned long)badgeValue];   
  
    badgeView.textColor = [UIColor whiteColor];
    badgeView .font =  DefaultFontSize(8);
    badgeView.layer.cornerRadius = 6;//圆形
    badgeView.layer.masksToBounds =  YES;
    badgeView.backgroundColor = NavigationBackgroundColor;//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x-5, y, 18, 12);//圆形大小为10
    [self addSubview:badgeView];
    
   
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end

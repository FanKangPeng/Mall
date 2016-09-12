//
//  Curves.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "Curves.h"

@implementation Curves


- (void)drawRect:(CGRect)rect {
            CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(ctx, 1);  //线宽
            CGContextSetAllowsAntialiasing(ctx, YES);
            CGContextSetRGBStrokeColor(ctx,220.00/255.00,220.00/255.00,220.00/255.00,1);  //颜色
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, 0, 10);  //起点坐标
            CGContextAddLineToPoint(ctx, 30, 10);   //终点坐标
            CGContextAddLineToPoint(ctx, 40, 10);   //终点坐标
            CGContextAddLineToPoint(ctx, 50, 10);   //终点坐标
            CGContextAddLineToPoint(ctx, kScreenWidth, 10
                                    );   //终点坐标
            CGContextStrokePath(ctx);
}
@end

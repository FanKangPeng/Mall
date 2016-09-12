//
//  BuyCountView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "BuyCountView.h"

@implementation BuyCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lb_name];

        [self addSubview:self.addView];

    }
    return self;
}


//颜色转图片
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}

- (UILabel *)lb_name
{
    if (!_lb_name) {
        _lb_name = [UILabel new];
        _lb_name.text = @"购买数量";
        _lb_name.font = DefaultFontSize(14);
        _lb_name.frame = CGRectMake(KLeft, KLeft, 100, 30);
    }
    return _lb_name;
}
- (AddNumberView *)addView
{
    if (!_addView) {
        _addView = [[AddNumberView alloc]initWithFrame:CGRectMake(kScreenWidth-120, KLeft, 108, 30)];
        _addView.numberString =@"5";
        _addView.backgroundColor = [UIColor clearColor];
    }
    return _addView;
}




@end

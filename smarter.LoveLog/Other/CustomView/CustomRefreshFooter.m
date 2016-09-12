//
//  CustomRefreshFooter.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "CustomRefreshFooter.h"

@implementation CustomRefreshFooter

- (void)prepare
{
    [super prepare];
   
    
    // 设置控件的高度
    self.mj_h = 35;
    
 
    
    
    self.logo = [[DACircularProgressView alloc] init];
    self.logo.progress= 0;
    self.logo.start = -M_PI_2;
    [self addSubview:self.logo];
    

    
}
-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
 
    
    self.logo.frame = CGRectMake(kScreenWidth/2 - 12.5,5, 25, 25);
  
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStatePulling:
        {
            self.logo.progress= 0;
            self.logo.start = -M_PI_2;
          
            
       
        }
            break;
        case MJRefreshStateRefreshing:
        {
         
            self.logo.progress=0.6;
            self.logo.start = M_PI;
    
            [self.timer fire];
        }
            break;
        case MJRefreshStateIdle:
        {
            self.logo.progress= 0;
            self.logo.start = -M_PI_2;
            if (_timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            
            
        }
            break;
        default:
            break;
    }
}
- (void)progressChange
{
    self.logo.start+=M_PI_4/4;
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (pullingPercent >=0.7) {
        pullingPercent -=1;
        self.logo.progress =1.5 * pullingPercent;
    }
    
    
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    //    CGFloat red = 1.0 - pullingPercent * 0.5;
    //    CGFloat green = 0.5 - 0.5 * pullingPercent;
    //    CGFloat blue = 0.5 * pullingPercent;
    //    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


@end

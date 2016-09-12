//
//  CustomRefreshHeader.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/29.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CustomRefreshHeader.h"
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
@implementation CustomRefreshHeader

- (void)prepare
{
    [super prepare];
    //从缓存中获取提示语句
    _something =[[NSUserDefaults standardUserDefaults] objectForKey:@"someThing"];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = NavigationBackgroundColor;
    label.font = DefaultFontSize(14);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    int xxx =(int)random()%[self.something count];
    self.label.text = self.something[xxx];
    
    self.logo = [[DACircularProgressView alloc] init];
    self.logo.progress = 0;
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
    
    self.label.frame = CGRectMake(0, 0, kScreenWidth, 15);;
    
    self.logo.frame = CGRectMake(kScreenWidth/2 -12.5,20, 25, 25);

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
//            int xxx =(int)random()%[self.something count];
//            self.label.text = self.something[xxx];
            self.logo.progress=0;
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
            
            
         
          
            self.logo.progress=0;
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
    
    if (pullingPercent >0 && pullingPercent <= 0.2) {
        int xxx =(int)random()%[self.something count];
        self.label.text = self.something[xxx];
    }
  
    if(pullingPercent >=0.7)
    {
        pullingPercent-=0.7;
       self.logo.progress  = pullingPercent;
    }
    
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


@end

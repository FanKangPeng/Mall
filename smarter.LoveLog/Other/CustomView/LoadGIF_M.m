//
//  LoadGIF_M.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "LoadGIF_M.h"

@implementation LoadGIF_M

-(instancetype)init
{
    self= [super initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.logo = [[DACircularProgressView alloc] initWithFrame:self.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.logo setBackgroundColor:[UIColor clearColor]];
    self.logo.progress = 0.6;
    [self addSubview:self.logo];
    [self.timer fire];
    time = 0;
    return self;
    
}
-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)progressChange
{
    self.logo.start+=M_PI_4/4;
    time++;
    if (time>3000) {
        time =0;
        [self.timer invalidate];
        self.timer = nil;
        [self.logo removeFromSuperview];
        self.logo = nil;
        
    }
}
-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [self.logo removeFromSuperview];
    self.logo = nil;
}
@end

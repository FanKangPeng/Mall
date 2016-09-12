//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation DACircularProgressView

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"M.png"];
    
    [image drawInRect:CGRectMake(rect.size.width/2-6,rect.size.height/2-6,12,12)];
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                                                         radius:10
                                                     startAngle:_start
                                                       endAngle:_start+M_PI*2*_progress
                                                      clockwise:YES];
    
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理

    aPath.lineWidth = 1.2;
    [NavigationBackgroundColor setStroke];

    [aPath stroke];
  
//    CGSize size = [@"M" sizeWithAttributes:@{NSFontAttributeName:SYSTEMFONT(18),NSForegroundColorAttributeName:NavigationBackgroundColor}];
//    [@"M" drawInRect:CGRectMake(rect.size.width/2-size.width/2,rect.size.height/2-size.height/2,size.width,size.height) withAttributes:@{NSFontAttributeName:SYSTEMFONT(18),NSForegroundColorAttributeName:NavigationBackgroundColor}];

}


-(void)setStart:(float)start
{
    _start = start;
    [self setNeedsDisplay];
}
- (void)setProgress:(float)progress
{

    if(progress >=1)
        _progress=1;
    else
        _progress = progress;

    [self setNeedsDisplay];
}

@end

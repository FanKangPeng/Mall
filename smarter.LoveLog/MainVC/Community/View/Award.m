//
//  Award.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "Award.h"


@implementation Award
+(Award *) sharedInstance{
    
    static Award *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
     return sharedInstace;
}
-(void)awardViewTapClick:(UIButton*)tap witheven:(UIEvent*)even
{
    //拿到点击的点的位置
    UITouch* touch = [[even touchesForView:tap] anyObject];
    CGPoint rootViewLocation = [touch locationInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
    CGFloat touchX  = rootViewLocation.x;
    CGFloat touchY = rootViewLocation.y-10;
    
    if(!isOpen)
    {
        QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"community_integral01"]
                                                                    highlightedImage:nil
                                                                        ContentImage:nil
                                                             highlightedContentImage:nil];
        QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"community_integral02"]
                                                                   highlightedImage:nil
                                                                       ContentImage:nil
                                                            highlightedContentImage:nil];
        QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"community_integral03"]
                                                                     highlightedImage:nil
                                                                         ContentImage:nil
                                                              highlightedContentImage:nil];
        menus = [NSMutableArray arrayWithObjects:cameraMenuItem, placeMenuItem, thoughtMenuItem, nil];
        
        
        mengceng =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [mengceng setBackgroundColor:[UIColor blackColor]];
        mengceng.alpha =0.3;
        
        toumingView   =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [toumingView setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengcengTap:)];
        tap.delegate =self;
        [toumingView addGestureRecognizer:tap];
        UIWindow * window =[UIApplication sharedApplication].delegate.window;
        
        
        [window addSubview:mengceng];
        [window addSubview:toumingView];
        
        for (int i = 0; i < menus.count; i ++)
        {
            QuadCurveMenuItem *item = [menus objectAtIndex:i];
            item.tag = 1000 + i;
            item.startPoint = CGPointMake(touchX, touchY);
            item.userInteractionEnabled = YES;
            
            if(touchX >kScreenWidth/2)
            {
                if(i==0)
                {
                    item.endPoint = CGPointMake(touchX-130,touchY-80);
                    item.nearPoint = CGPointMake(touchX-55,touchY-40);
                    item.farPoint =CGPointMake(touchX-150, touchY-100);
                    item.center = item.startPoint;
                }
                
                if(i==1)
                {
                    item.endPoint = CGPointMake(touchX-70,touchY-70);
                    item.nearPoint = CGPointMake(touchX-40,touchY-30);
                    item.farPoint =CGPointMake(touchX-90, touchY-90);
                    item.center = item.startPoint;
                }
                if(i==2)
                {
                    item.endPoint = CGPointMake(touchX-5,touchY-45);
                    item.nearPoint = CGPointMake(touchX-5,touchY-25);
                    item.farPoint =CGPointMake(touchX-5, touchY-65);
                    item.center = item.startPoint;
                }
            }
            else
            {
                if(i==0)
                {
                    item.endPoint = CGPointMake(touchX+130,touchY-80);
                    item.nearPoint = CGPointMake(touchX+55,touchY-40);
                    item.farPoint =CGPointMake(touchX+150, touchY-100);
                    item.center = item.startPoint;
                }
                
                if(i==1)
                {
                    item.endPoint = CGPointMake(touchX+70,touchY-70);
                    item.nearPoint = CGPointMake(touchX+40,touchY-30);
                    item.farPoint =CGPointMake(touchX+90, touchY-90);
                    item.center = item.startPoint;
                }
                if(i==2)
                {
                    item.endPoint = CGPointMake(touchX+5,touchY-45);
                    item.nearPoint = CGPointMake(touchX+5,touchY-25);
                    item.farPoint =CGPointMake(touchX+5, touchY-65);
                    item.center = item.startPoint;
                }
            }
            
            item.delegate = self;
            [item setHidden:YES];
            [toumingView addSubview:item];
        }
        
        
    }
    
    
    if(isOpen)
    {
        [self _close];
    }
    else
    {
        [self _expand];
    }
    isOpen = !isOpen;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIImageView class]]){
        
        return NO;
        
    }
    
    return YES;
    
}


-(void)mengcengTap:(UITapGestureRecognizer*)tap
{
    [toumingView removeFromSuperview];
    toumingView = nil;
    [mengceng removeFromSuperview];
    mengceng = nil;
}
- (void)_expand
{
    for (int i =0; i<3; i++)
    {
        
        QuadCurveMenuItem *item = menus[i];
        [item setHidden:NO];
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.0f], nil];
        rotateAnimation.duration = 0.3f;
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:.3],
                                    [NSNumber numberWithFloat:.4], nil];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.3f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
        animationgroup.duration = 0.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Expand"];
        item.center = item.endPoint;
        
        
    }
    
    
    
}

- (void)_close
{
    for (int i =0; i<3; i++)
    {
        
        QuadCurveMenuItem *item = menus[i];
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.0f], nil];
        rotateAnimation.duration = 0.5f;
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:.0],
                                    [NSNumber numberWithFloat:.4],
                                    [NSNumber numberWithFloat:.5], nil];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
        animationgroup.duration = 0.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Close"];
        item.center = item.startPoint;
        [item removeFromSuperview];
        
    }
    
    
}

#pragma mark QuadcurveMenuitem delegate
- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item
{
    
}
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item
{
    _item = item;
//    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center anditem:item];
//    blowup.delegate=self;
//    [item.layer addAnimation:blowup forKey:@"blowup"];
    
    int rewardID = 0 ;
    for (int i = 0; i < [menus count]; i ++)
    {
        QuadCurveMenuItem *otherItem = [menus objectAtIndex:i];
   //     CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        
        
        
        if (otherItem.tag == item.tag) {
            rewardID = i;
            continue;
        }
//        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
//        
//        [otherItem setHidden:YES];
        
        
        
    }
    NSString * rewardCount;
    switch (rewardID) {
        case 0:
            rewardCount =@"5";
            break;
        case 1:
            rewardCount =@"10";
            break;
        case 2:
            rewardCount =@"15";
            break;
            
        default:
            break;
    }
     _AwardBlock(rewardCount);
    
}
-(void)awardSuccess
{
    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:_item.center anditem:_item];
    blowup.delegate=self;
    [_item.layer addAnimation:blowup forKey:@"blowup"];
    
    int rewardID = 0 ;
    for (int i = 0; i < [menus count]; i ++)
    {
        QuadCurveMenuItem *otherItem = [menus objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        
        
        
        if (otherItem.tag == _item.tag) {
            rewardID = i;
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        [otherItem setHidden:YES];
    }

}
-(void)awardFailer
{
    for (int i = 0; i < [menus count]; i ++)
    {
        QuadCurveMenuItem *otherItem = [menus objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
         shrink.delegate =self;
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
       
        [otherItem setHidden:YES];
    }
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p anditem:(QuadCurveMenuItem*)item
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.5f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 1.0f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.5f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (toumingView) {
        [toumingView removeFromSuperview];
        toumingView = nil;
       
    }
    if (mengceng) {
        [mengceng removeFromSuperview];
        mengceng = nil;
        
    }
   
   
    
}
@end

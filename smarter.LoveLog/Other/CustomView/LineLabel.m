//
//  LineLabel.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "LineLabel.h"
#import <CoreText/CoreText.h>

@implementation LineLabel

-(void)drawRect:(CGRect)rect
{
    
    [super drawTextInRect:rect];
    
    CGSize textSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    
    CGFloat strikeWidth = textSize.width;
    
    CGRect lineRect;
    
//    if ([self textAlignment] == NSTextAlignmentRight)
//    {
//        // 画线居中
//        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 1);
//        
//        // 画线居下
//        //lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
//    }
//    else if ([self textAlignment] == NSTextAlignmentCenter)
//    {
//        // 画线居中
//        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1);
//        
//        // 画线居下
//        //lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
//    }
//    else
//    {
//        // 画线居中
//        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
//        
//        // 画线居下
//        //lineRect = CGRectMake(0, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
//    }
   
    lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
    if (self.strikeThroughEnabled)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [self strikeThroughColor].CGColor);
        
        CGContextFillRect(context, lineRect);
    }

}
@end

//
//  SecondView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/3.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
@protocol SecondViewDelegate <NSObject>

-(void)backTop;
-(void)buyerEstimate;

@end


@interface SecondView : UIView
{
    UIWebView * _webView;
    UIView * _commentsView;
    UIWebView * _specificationView;
    NSUInteger buttonTag;
    UILabel * line;
    UIView * titleView;
    NSArray * cellTitleArr;
    NSArray * cellContentArr;
}
@property (nonatomic,assign)id<SecondViewDelegate>delegate;
@property( nonatomic,strong)GoodModel * goodModel;
@end

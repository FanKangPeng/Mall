//
//  CustomNavigationView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/2.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CustomNavigationView.h"
#import "ShareManager.h"

@implementation CustomNavigationView
-(void)setShareDict:(NSDictionary *)shareDict
{
    _shareDict = shareDict;
}

-(void)initViewWithTitle:(NSString *)title andBack:(NSString*)backName andRightName:(NSString*)rightName
{
     [self removeAllSubviews];
     //[self drawLineForNavigationLow];
      [self setBackgroundColor:NavigationBackgroundColor];
    
    [self initViewWithBack:backName andTitle:title andCustomRightButton:rightName];
    
}
-(void)initViewWithTitle:(NSString *)title Back:(NSString*)backName andRightName:(NSString*)rightName andAlpha:(CGFloat)Alpha;
{
   [self removeAllSubviews];
    
    UIView * view1 =[[UIView alloc] initWithFrame:self.frame];
    [view1 setBackgroundColor:NavigationBackgroundColor];
    view1.alpha = Alpha;
    [self addSubview:view1];
    
    UIView * view2 =[[UIView alloc] initWithFrame:self.frame];
    [view2 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:view2];
    if(Alpha>=1)
    {
        [view2 setHidden:YES];
        UILabel * titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120, 20, 240, 44)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:DefaultBoldFontSize(18)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:title];
        [view1 addSubview:titleLabel];
        [self initLucencyBackBtnWithImageName:backName andSupView:view1];
        [self initLucencyShareBtnWithImageName:rightName andSupView:view1];
    }
    else
    {
        [view2 setHidden:NO];
        [self initLucencyBackBtnWithImageName:backName andSupView:view2];
        [self initLucencyShareBtnWithImageName:rightName andSupView:view2];
        
    }
   
}
/**
 title  and back custombutton
 */

-(void)initViewWithBack:(NSString *)backName andTitle:(NSString*)titleName andCustomRightButton:(NSString*)rightButtonName
{
    if(![backName isEqualToString:@""])
    {
        if([backName hasSuffix:@".png"])
        {
               [self initBackBtnWithImageName:backName];
        }
        else
            [self initCustomLeftBtn:backName];
     
    }
    
    if(![rightButtonName isEqualToString:@""])
    {
        if([rightButtonName hasSuffix:@".png"])
        {
               [self initShareBtnWithImageName:rightButtonName];
        }
        else
            [self initCustomRightBtn:rightButtonName];
       
    }
    
    if(![titleName isEqualToString:@""])
    {
        if([titleName hasSuffix:@"png"])
        {
            [self initImageTitleWithImageName:titleName];
        }
        else
            [self initTitleWithTitle:titleName];
    }

}
/**
 返回按钮
 */
-(void)initBackBtnWithImageName:(NSString *)imageName
{
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(-7, 20, 44, 44)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:leftBtn];
}
/**
 分享按钮
 */
-(void)initShareBtnWithImageName:(NSString *)imageName
{
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(kScreenWidth-40, 20, 44, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if([imageName isEqualToString:@"icon_right_share.png"])
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchDown];
    else
          [shareBtn addTarget:self action:@selector(CustomshareBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:shareBtn];
    
}
/**
 透明返回按钮
 */
-(void)initLucencyBackBtnWithImageName:(NSString *)imageName andSupView:(UIView*)subview
{
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 20, 44, 44)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchDown];
    [subview addSubview:leftBtn];
}
/**
 透明分享按钮
 */
-(void)initLucencyShareBtnWithImageName:(NSString *)imageName andSupView:(UIView*)subview
{
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(kScreenWidth-44, 20, 44, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchDown];

    [subview addSubview:shareBtn];
    
}
/**
 自定义文字右按钮
 */
-(void)initCustomRightBtn:(NSString*)string
{
    UIButton * CustomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [CustomBtn setFrame:CGRectMake(kScreenWidth-100, 20, 85, 44)];
    [CustomBtn setTitle:string forState:UIControlStateNormal];
    CustomBtn.titleLabel.font =DefaultFontSize(14);
    [CustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [CustomBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
   // [CustomBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 18, 0)];
    CustomBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [CustomBtn addTarget:self action:@selector(customRightBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:CustomBtn];
}
/**
 自定义文字左按钮
 */
-(void)initCustomLeftBtn:(NSString*)string
{
    UIButton * CustomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [CustomBtn setFrame:CGRectMake(15, 20, 85, 44)];
    [CustomBtn setTitle:string forState:UIControlStateNormal];
    CustomBtn.titleLabel.font =DefaultFontSize(14);
    [CustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CustomBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [CustomBtn addTarget:self action:@selector(customLeftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:CustomBtn];
}
/**
文字 title
 */
-(void)initTitleWithTitle:(NSString*)title
{
    UILabel * titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120, 20, 240, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:DefaultBoldFontSize(18)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [self addSubview:titleLabel];
}
/**
 图片title
 */
-(void)initImageTitleWithImageName:(NSString*)imageName
{
    UIImageView * titleImage =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-43.5, 31, 87, 23)];
    [titleImage setImage:[UIImage imageNamed:imageName]];
    [self addSubview:titleImage];
}

#pragma back and share click action
/*
 *自定义右按钮
 */
-(void)CustomshareBtnClick:(UIButton*)shareBtn
{
    _CustomNavigationRightImageBlock();
}
/**
 分享
 */
-(void)shareBtnClick:(UIButton*)shareBtn
{
       [[ShareManager sharedInstance]createShareContentWithShareDict:self.shareDict andShareView:self];
}
/**
 返回
 */
-(void)backBtnClick:(UIButton*)shareBtn
{
    _CustomNavigationLeftImageBlock();
    
}
/**
 自定义文字左button事件
 */
-(void)customLeftBtnClick:(UIButton*)customBtn
{
    _CustomNavigationCustomLeftBtnBlock();
}
/**
 自定义文字右button事件
 */
-(void)customRightBtnClick:(UIButton*)customBtn
{
    _CustomNavigationCustomRightBtnBlock(customBtn);
}
/**
 模仿导航条底部的线
 */
-(void)drawLineForNavigationLow
{
    UILabel * line  =[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-SINGLE_LINE_WIDTH/4, kScreenWidth, SINGLE_LINE_WIDTH/4)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self addSubview:line];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

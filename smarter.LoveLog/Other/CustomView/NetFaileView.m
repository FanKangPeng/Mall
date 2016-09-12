//
//  NetFaileView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/9.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "NetFaileView.h"

@implementation NetFaileView

-(instancetype)initNetFaileViewWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    //[self initView];
    return self;
}
-(instancetype)initShopCartNullView:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    [self initShopCartNullView];
    return self;
}
-(instancetype)initLoadImageFaile
{
    self =[super initWithFrame:CGRectMake(0, 0, 100, 100)];
 
    return self;
}
-(void)initShopCartNullView
{
    
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-42, 0, 84, 84)];
    [imageView setImage:[[UIImage imageNamed:@"cartNoContentIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addSubview:imageView];
    UILabel * label1 =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-70,115, 140, 20)];
    [label1 setText:@"购物车还是空的哦"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:FontColor_black];
    [label1 setFont:DefaultFontSize(14)];
    [self addSubview:label1];
    UILabel * label2 =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-70,135, 140, 20)];
    [label2 setText:@"快去逛逛吧~"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:FontColor_black];
    [label2 setFont:DefaultFontSize(14)];
    [self addSubview:label2];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(self.frame.size.width/2-65, 175, 130, 35)];
    [button setBackgroundColor:NavigationBackgroundColor];
    button.layer.cornerRadius=15;
    button.layer.masksToBounds=YES;
    [button setTitle:@"逛一逛" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:DefaultFontSize(18)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
}
-(void)buttonClick:(UIButton*)button
{
    _StrollButtonBlock();
}
-(void)reloadBtn:(UIButton*)button
{
    _NetFaileReloadBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

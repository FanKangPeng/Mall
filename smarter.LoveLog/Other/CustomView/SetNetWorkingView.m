//
//  SetNetWorkingView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/9.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SetNetWorkingView.h"

@implementation SetNetWorkingView
-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    [self initView];
    return self;
}
-(void)initView
{
    [self setBackgroundColor:[UIColor grayColor]];
    UIImageView * imageview =[[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 15, 15)];
    imageview.image =[UIImage imageNamed:@"network_icon"];
    [self addSubview:imageview];
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(40, 7, kScreenWidth-100, 30)];
    label.text=@"网络请求失败，请检查您的网络设置";
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:DefaultFontSize(16)];
    [self addSubview:label];

    UIImageView * iamge =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 12, 10, 20)];
    iamge.image =[UIImage imageNamed:@"icon_right_more"];
    [self addSubview:iamge];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}
-(void)tapClick:(UITapGestureRecognizer*)tap
{
    _SetNetWorkingBlock();
    /*
     跳转到手机设置页面
     NSURL*url =[NSURL URLWithString:@"prefs:root=Setting"];
     [[UIApplication sharedApplication] openURL:url];
     */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

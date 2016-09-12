//
//  AttentionViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/23.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AttentionViewController.h"

@implementation AttentionViewController
#pragma mark - life Cycle
-(void)viewDidLoad
{
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"我的关注" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:NavigationView];
    
    
}
@end

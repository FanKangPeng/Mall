//
//  ChatViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/15.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ChatViewController.h"
#import "CustomNavigationView.h"



@implementation ChatViewController

-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBar.barTintColor =NavigationBackgroundColor;
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:BackgroundColor];
     self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_APPSERVICE)
                                                                         ]];
    if (unreadMsgCount >0 &&  [UIApplication sharedApplication].applicationIconBadgeNumber >= unreadMsgCount) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber - unreadMsgCount;
    }
    
    self.enableSaveNewPhotoToLocalSystem = YES;
     self.conversationType =ConversationType_APPSERVICE;
    self.targetId=@"KEFU145016175783968";
    CustomNavigationView * mainNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [mainNavigationView initViewWithTitle:@"在线客服" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    mainNavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:mainNavigationView];
}

@end

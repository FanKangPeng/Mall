//
//  BaseViewController.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//





#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NotReachView.h"
#import "CustomNavigationView.h"
#import "LoginViewController.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>

- (void)presentViewController:(UIViewController*)viewContrller;


@end

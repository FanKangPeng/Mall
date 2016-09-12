//
//  SecondBaseViewController.h
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/26.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationView.h"
#import "CustomRefreshHeader.h"
#import "CustomRefreshFooter.h"
#import "LoginViewController.h"
#import "NoDataView.h"
#import "NetFaileView.h"
#import "NotReachView.h"
@interface SecondBaseViewController : UIViewController

- (void)presentViewController:(UIViewController*)viewContrller;

@end

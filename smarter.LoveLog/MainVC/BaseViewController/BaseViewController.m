
//
//  BaseViewController.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "BaseViewController.h"

#import "UITabBar+Badge.h"
#import "FMDBManager.h"
#import "HomeDataTool.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self manageCartCount];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =BackgroundColor;
 
    
    // Do any additional setup after loading the view.
}
/**
 *  购物车图标数量处理
 *
 *  @return
 */
- (void)manageCartCount
{
    if (!isLogin) {
        int  count  = [FMDBManager selectCount];
        if(count >0)
            
            [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count];
        else
        {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
      
    }
    else
    {
        //从服务器获取
        [HomeDataTool getsomeThing:@"/cart/number" success:^(id obj) {
            NSDictionary * dict = [obj objectForKey:@"data"];
            NSString * str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cart_number"]];
            if (![str isEqualToString:@"<null>"]) {
              
                [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:[str intValue]];
            }
            else
            {
              
                [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
            }
            
            
           
        } failure:^(id obj) {
            nil;
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
 
    hud = nil;
}

- (void)presentViewController:(UIViewController*)viewContrller
{
     [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:viewContrller animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


//
//  SecondBaseViewController.m
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/26.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface SecondBaseViewController ()

@end

@implementation SecondBaseViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
     [self.view setBackgroundColor:BackgroundColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:BackgroundColor];
    //present 弹出风格
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    // 翻页动画
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   
    // Do any additional setup after loading the view.
}

- (void)presentViewController:(UIViewController*)viewContrller
{
     [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:viewContrller animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

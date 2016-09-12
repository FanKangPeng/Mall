//
//  FavorableViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FavorableViewController.h"

@interface FavorableViewController ()

@end

@implementation FavorableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView *NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"优惠卷" andBack:@"icon_back.png" andRightName:@"" ];
    [self.view addSubview:NavigationView];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf.lcNavigationController popViewController];
        
    };
    // Do any additional setup after loading the view.
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

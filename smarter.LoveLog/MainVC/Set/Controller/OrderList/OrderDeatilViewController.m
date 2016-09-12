//
//  OrderDeatilViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "OrderDeatilViewController.h"

@interface OrderDeatilViewController ()

@end

@implementation OrderDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:@"订单详情" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:setNavigationView];
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

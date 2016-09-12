//
//  ViewController.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "ViewController.h"

#import "ShopCartViewController.h"
#import "MainViewController.h"
#import "UserInfoCenterViewController.h"
#import "CommunityViewController.h"

#import <LCNavigationController/LCNavigationController.h>

#import "AFNetHttp.h"

#import "UITabBar+Badge.h"
@interface ViewController ()

@end

@implementation ViewController

#pragma mark -  life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString * versionString =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * cacheVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    if(![cacheVersion isEqualToString:versionString])
    {
        [self.view addSubview:self.launchImage];
        [self getSliderData];
        
    }
    else
        [self createStartImage];
    
    
   
       // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - server method
-(NSArray*)getSliderData
{
    __block NSMutableArray * array =[NSMutableArray array];
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:@"guide" params:nil session:YES success:^(NSDictionary *response) {
        array = [NSMutableArray arrayWithArray:[response objectForKey:@"data"]];
        [weakSelf.launchImage removeFromSuperview];
        [weakSelf createScrollPageWithArr:array];
    } failure:^(id error) {
       [self createStartImage];
    }];
    
    
    return array;
}
//创建引导页轮播图

-(void)createScrollPageWithArr:(NSArray *)arr
{
    //获取轮播图
    
    //   NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
      //  NSArray *backgroundImageNames =@[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:arr backgroundImageNames:arr];
    
    [self.view addSubview:self.introductionView.view];
    
    __block ViewController * weakSelf = self;
    self.introductionView.didSelectedEnter = ^() {
        weakSelf.introductionView = nil;
        [weakSelf createStartImage];
    };
    
}
-(void)createStartImage
{
    //初始化存放tab title 和icon 的数组
    self.tabTitleArr  =[NSArray arrayWithObjects:@"首页",@"社区",@"购物车",@"我的", nil];
    self.tabIconArr =[NSArray arrayWithObjects:@"",@"",@"",@"",nil];
    //先获取数据 如果有新广告 加载新广告页
    //从接口中获取tab的icon地址数组，添加到tabIconArr
    
    self.ViewCreateTabbarBlock();
    
    
    
}
- (void (^)())ViewCreateTabbarBlock
{
    if (!_ViewCreateTabbarBlock) {
        __WEAK_SELF_YLSLIDE
        _ViewCreateTabbarBlock = ^{
            MainViewController * mainVC  =[[MainViewController alloc] init];
            
            UIImageView * mainImage  =[[UIImageView alloc] init];
            [mainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[0]]] placeholderImage:[UIImage imageNamed:@"main_tabbar_icon"]];
            UIImageView * main_selectedImage  =[[UIImageView alloc] init];
            [main_selectedImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[0]]] placeholderImage:[UIImage imageNamed:@"main_tabbar_icon_selected"]];
            mainVC.tabBarItem =[mainVC.tabBarItem initWithTitle:weakSelf.tabTitleArr[0] image:[mainImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[main_selectedImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            
            CommunityViewController * CommunityVC  =[[CommunityViewController alloc] init];
            UIImageView * CommunityImage  =[[UIImageView alloc] init];
            [CommunityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[1]]] placeholderImage:[UIImage imageNamed:@"community_tabbar_icon"]];
            UIImageView *Community_selectedImage  =[[UIImageView alloc] init];
            [Community_selectedImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[0]]] placeholderImage:[UIImage imageNamed:@"community_tabbar_icon_selected"]];
            CommunityVC.tabBarItem =[CommunityVC.tabBarItem initWithTitle:weakSelf.tabTitleArr[1] image:[CommunityImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[Community_selectedImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            
            
            ShopCartViewController * shopVC  =[[ShopCartViewController alloc] init];
            shopVC.isOtherVCPush = NO;
            UIImageView * shopImage  =[[UIImageView alloc] init];
            [shopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[2]]] placeholderImage:[UIImage imageNamed:@"shopCart_tabbar_icon"]];
            UIImageView *shop_selectedImage  =[[UIImageView alloc] init];
            [shop_selectedImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[0]]] placeholderImage:[UIImage imageNamed:@"shopCart_tabbar_icon_selected"]];
            shopVC.tabBarItem =[shopVC.tabBarItem initWithTitle:weakSelf.tabTitleArr[2] image:[shopImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[shop_selectedImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            
            
            
            UserInfoCenterViewController * setVC  =[[UserInfoCenterViewController alloc] init];
            UIImageView * setImage  =[[UIImageView alloc] init];
            [setImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[3]]] placeholderImage:[UIImage imageNamed:@"userInfo_tabbar_icon"]];
            UIImageView *set_selectedImage  =[[UIImageView alloc] init];
            [set_selectedImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.tabIconArr[0]]] placeholderImage:[UIImage imageNamed:@"userInfo_tabbar_icon_selected"]];
            setVC.tabBarItem =[setVC.tabBarItem initWithTitle:weakSelf.tabTitleArr[3] image:[setImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[set_selectedImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            
            NSArray * tabbarArr  =@[mainVC ,CommunityVC,shopVC,setVC];
            UITabBarController * tabbar  =[[UITabBarController alloc] init];
            tabbar.viewControllers = tabbarArr;
            //tabbar 背景颜色
            UIView * tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBottomBarHeight)];
            [tabView setBackgroundColor:[UIColor whiteColor]];
            [tabbar.tabBar insertSubview:tabView atIndex:0];
            
            // 字体颜色 选中
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : DefaultFontSize(11), NSForegroundColorAttributeName : NavigationBackgroundColor} forState:UIControlStateSelected];
            
            // 字体颜色 未选中
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : DefaultFontSize(11),  NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
            
            // 图标颜色
            tabbar.tabBar.tintColor = NavigationBackgroundColor;
            
          //  [tabbar.tabBar showBadgeOnItemIndex:2 badgeValue:10];
            
            LCNavigationController *navC = [[LCNavigationController alloc] initWithRootViewController:tabbar];
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            window.rootViewController = navC;
            
        };
    }
    return _ViewCreateTabbarBlock;
}
- (UIImageView *)launchImage{
    
    if (_launchImage == nil) {
        _launchImage = [[UIImageView alloc] initWithFrame:kScreenBounds];
        _launchImage.image = [UIImage imageNamed:@"Default"];
    }
    
    return _launchImage;
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

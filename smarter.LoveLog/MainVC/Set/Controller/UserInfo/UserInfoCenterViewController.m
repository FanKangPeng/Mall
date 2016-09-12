//
//  UserInfoCenterViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "UserInfoCenterViewController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "OrderTableViewCell.h"
#import "OtherTableViewCell.h"
#import "CollectionTableViewCell.h"
#import "OrderListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RedPacketViewController.h"
#import "UserInfoViewController.h"
#import "MoneyViewController.h"
#import "IntegralViewController.h"
#import "AdressManagerViewController.h"
#import "NotificationViewController.h"
#import "FeedbackViewController.h"
#import "MyPostsViewController.h"
#import "MyCommentViewController.h"
#import "UserInfoTool.h"
#import "MessageListViewController.h"
#import "CollectViewController.h"
#import "AttentionViewController.h"
#import "MyKeyChainHelper.h"
#import "AFNetHttp.h"
#import "UITabBar+Badge.h"
#import "FMDBManager.h"
#define HeadView_Height kScreenWidth* 0.43
@interface UserInfoCenterViewController ()

@end

@implementation UserInfoCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    if ([self respondsToSelector:@selector(getUserInfo)]) {
         [self getUserInfo];
    }
     [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.mainView];
    // Do any additional setup after loading the view.
}

- (void)getUserInfo
{
    [UserInfoTool userInfo:@"/user/info" params:nil success:^(id obj) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [dict setObject:[obj objectForKey:@"user_name"] forKey:@"name"];
        self.userInfoModel =[UserInfoModel mj_objectWithKeyValues:dict];
        //更新本地用户信息
        NSMutableData* data = [[NSMutableData alloc]init];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dict forKey:@"userInfoModel"];
        [archiver finishEncoding];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfoModel"];
        //更新session
        self.headView.userInfo =self.userInfoModel;
    } failure:^(id obj) {
        //清除用户信息的缓存
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
//        [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
//        self.userInfoModel = nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                //清除session
                [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
                
                self.headView.userInfo =nil;
            }
        }
    }];
}

-(UITableView *)mainView
{
    if(!_mainView)
    {
        _mainView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomBarHeight) style:UITableViewStylePlain];
        _mainView.delegate =self;
        _mainView.dataSource =self;

        [_mainView setBackgroundColor:BackgroundColor];
        _mainView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_mainView addSubview: self.headView];
        _mainView.contentInset = UIEdgeInsetsMake(HeadView_Height, 0, 0, 0);
    }
    return _mainView;
}
-(UserInfoCenterHeadView *)headView
{
    if(!_headView)
    {
      __WEAK_SELF_YLSLIDE
        _headView =[[UserInfoCenterHeadView alloc] initWithFrame:CGRectMake(0, -HeadView_Height, kScreenWidth, HeadView_Height)];
        _headView.PortraitImageViewBlock=^{
            UserInfoViewController * userInfoView = [[UserInfoViewController alloc] init];
       
            [weakSelf.lcNavigationController pushViewController:userInfoView];
        };
        _headView.LoginButtonBlock=^{
          [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
           
        };
        _headView.SetButtonBlock=^{
            SetViewController * setView = [[SetViewController alloc] init];
           
            [weakSelf.lcNavigationController pushViewController:setView];
        };
        
    }
    return _headView;
}

#pragma mark  tableview delegate and datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return  100;
            break;
        case 1:
            return 10;
            break;
//        case 2:
//            return 100;
            break;
        case 2:
            return kScreenWidth*0.76;
            break;
        case 3:
            return 70;
            break;
            
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cell_reuseIdentifier =@"reuseIdentifier";
    switch (indexPath.section)
    {
        case 0:
        {
            OrderTableViewCell * orderCell =[tableView dequeueReusableCellWithIdentifier:cell_reuseIdentifier];
            if(orderCell == nil)
            
                orderCell  =[[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_reuseIdentifier andDict:nil];
            
            __WEAK_SELF_YLSLIDE
           orderCell.OrderCellBlock=^(NSUInteger type) {
                    if (isLogin) {
                     //订单页面
                     OrderListViewController * orderListVC  =[[OrderListViewController alloc] init];
                     if(type ==1000)
                     {
                         //待付款
                         orderListVC.typeString=@"2";
                         orderListVC.title = @"待付款订单";
                     }
                     else if (type==1001)
                     {
                         //待收货
                         orderListVC.typeString=@"3";
                         orderListVC.title = @"待收货订单";
                     }
                     else if (type==1002)
                     {
                         //退款/退货
                         orderListVC.typeString=@"6";
                         orderListVC.title = @"退款/退货";
                     }
                     else
                     {
                         //订单页面
                         orderListVC.typeString=@"1";
                         orderListVC.isShowTitle = YES;
                         orderListVC.title = @"我的订单";
                         
                         
                     }
                     [weakSelf.lcNavigationController pushViewController:orderListVC];
                 }
                 else
                 {
                   [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                 }

               
             
           };
            return orderCell;
            
        }
            break;
        case 1:
        {
            OtherTableViewCell * otherCell =[tableView dequeueReusableCellWithIdentifier:cell_reuseIdentifier];
            if(otherCell == nil)
                
                otherCell  =[[OtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_reuseIdentifier andDict:nil];
            
            return otherCell;
            
        }
            break;
//        case 2:
//        {
//            OtherTableViewCell * otherCell =[tableView dequeueReusableCellWithIdentifier:cell_reuseIdentifier];
//            NSDictionary * dict =@{@"labelText":@"尊爱的客户：由于系统改造，2015年12月12日旧版爱的日志历史订单不支持线上申请，售后服务请致电售后客服中心。2015年12月12日旧版"};
//            if(otherCell == nil)
//                
//                otherCell  =[[OtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_reuseIdentifier andDict:dict];
//            
//            return otherCell;
//            
//        }
//            break;
        case 2:
        {
            CollectionTableViewCell * collectionCell =[tableView dequeueReusableCellWithIdentifier:cell_reuseIdentifier];
            NSDictionary * dict =@{@"labelText":@[@[@"帖子",@"评论",@"收藏",@"关注"],@[@"钱包",@"红包",@"积分",@"地址"],@[@"消息",@"通知",@"咨询",@"反馈"]]};
            if(collectionCell == nil)
                
                collectionCell  =[[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_reuseIdentifier andDict:dict];
            
            __WEAK_SELF_YLSLIDE
            
            collectionCell.CollectionCellBlock=^(NSString *name) {

                if (isLogin) {
                    if ([name isEqualToString:@"红包"]) {
                        [weakSelf.lcNavigationController pushViewController:[[RedPacketViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"钱包"]) {
                        [weakSelf.lcNavigationController pushViewController:[[MoneyViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"积分"]) {
                        [weakSelf.lcNavigationController pushViewController:[[IntegralViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"地址"]) {
                        [weakSelf.lcNavigationController pushViewController:[[AdressManagerViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"咨询"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:nil];
                    }
                    if ([name isEqualToString:@"通知"]) {
                        [weakSelf.lcNavigationController pushViewController:[[NotificationViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"反馈"]) {
                        [weakSelf.lcNavigationController pushViewController:[[FeedbackViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"帖子"]) {
                        [weakSelf.lcNavigationController pushViewController:[[MyPostsViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"评论"]) {
                        [weakSelf.lcNavigationController pushViewController:[[MyCommentViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"消息"]) {
                        [weakSelf.lcNavigationController pushViewController:[[MessageListViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"收藏"]) {
                        [weakSelf.lcNavigationController pushViewController:[[CollectViewController alloc] init]];
                    }
                    if ([name isEqualToString:@"关注"]) {
                        [weakSelf.lcNavigationController pushViewController:[[AttentionViewController alloc] init]];
                    }
                }
                else
                {
                  [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                }
                
                
            };
            return collectionCell;
            
        }
            break;
        case 3:
        {
            OtherTableViewCell * otherCell =[tableView dequeueReusableCellWithIdentifier:cell_reuseIdentifier];
            NSDictionary * dict =@{@"button":@"联系客服"};
            if(otherCell == nil)
                
                otherCell  =[[OtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_reuseIdentifier andDict:dict];
            
            otherCell.otherCellBlock = ^{
                if (isLogin) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:nil];
                }
                else
                {
                 [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                }
            };
            
            return otherCell;
            
        }
            break;
            
        default:
            break;
    }
    UITableViewCell * cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return cell;
}
#pragma mark  scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
  
    if (yOffset < -HeadView_Height) {
        CGRect f = self.headView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.headView.frame = f;
    }
    else
    {
        self.headView.frame = CGRectMake(0, -HeadView_Height, kScreenWidth, HeadView_Height);
    }
}
/**
 网络加载失败页面
 */
-(void)netFaileView
{
    //网络加载失败页面
    NetFaileView * netFaileView =[[NetFaileView alloc] initNetFaileViewWithFrame:CGRectMake(0, self.view.frame.size.height/2-75, self.view.frame.size.width, 150)];
   
    netFaileView.NetFaileReloadBlock=^{
        //
    };
    [self.view addSubview:netFaileView];
    
    SetNetWorkingView * setnetview =[[SetNetWorkingView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kNavigationHeight)];
    setnetview.SetNetWorkingBlock=^{
        //跳转到设置
        
        NSURL*url =[NSURL URLWithString:@"prefs:root=Setting"];
        [[UIApplication sharedApplication] openURL:url];
        
    };
    [self.view addSubview:setnetview];
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

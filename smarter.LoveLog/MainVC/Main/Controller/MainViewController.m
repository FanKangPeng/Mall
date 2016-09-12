//
//  MainViewController.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "MainViewController.h"
#import "CarouselTableViewCell.h"
#import "EventTableViewCell.h"
#import "ClassifyTableViewCell.h"
#import "AdvertisementTableViewCell.h"
#import "Action.h"
#import "RCDLoginInfo.h"
#import "CustomRefreshHeader.h"
#import "HomeDataTool.h"
#import "FuncationTableViewCell.h"
#import "ActivityViewController.h"
#import "MaskDetailViewController.h"
#import "MessageListViewController.h"
#import "CommunityListViewController.h"
#import "CommeunityDetailViewController.h"
#import "HelpViewController.h"
#import "HelpNextViewController.h"
#import "HelpDeatilViewController.h"
#import "ActivityViewController.h"
#import "AFNetHttp.h"
#import "UserInfoTool.h"
#import "FMDBManager.h"
#import "UITabBar+Badge.h"
@interface MainViewController ()
@property (nonatomic,strong)NSDictionary * contentDict;
@property(nonatomic,strong) NotReachView * noreachView;
@end

@implementation MainViewController

#pragma mark - lifre Cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
  //添加导航view
    CustomNavigationView * mainNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [mainNavigationView initViewWithTitle:@"icon_Logo.png" andBack:@"icon_List.png" andRightName:@"icon_Message.png"];
     __WEAK_SELF_YLSLIDE
    mainNavigationView.CustomNavigationLeftImageBlock=^{
        //
         HUDSHOW(@"敬请期待");
    };
   
    mainNavigationView.CustomNavigationRightImageBlock=^{
        //
         if (isLogin) {
             [weakSelf.lcNavigationController pushViewController:[[MessageListViewController alloc] init]];
         }
        else
        {
         [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        }
    };
    [self.view addSubview:mainNavigationView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAdver:) name:@"advertisement" object:nil];
   
   
    [self getServerData];
   
    // Do any additional setup after loading the view.
}
- (void)pushToAdver:(NSNotification*)notification
{
    NSString * link_url = notification.object;
    ActivityViewController * vc = [[ActivityViewController alloc] init];
    vc.url = link_url;
    [self.lcNavigationController pushViewController:vc];
}
//创建主体UI
-(void)createMainView
{
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    if(!_mainTabelView)
    {
        _mainTabelView  =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
        [_mainTabelView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight*5)];
        _mainTabelView.delegate =self;
        [_mainTabelView setBackgroundColor:BackgroundColor];
        _mainTabelView.dataSource =self;
        //下啦刷新
        
        //       [_mainTabelView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //           [weakSelf loading];
        //       }]];
        _mainTabelView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loading)];
        
        [self.view addSubview:_mainTabelView];
        _mainTabelView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    else
    {
        [self.mainTabelView.mj_header endRefreshing];
        [self.mainTabelView.mj_footer endRefreshing];
        [_mainTabelView reloadData];
    }
    
}
-(void)createNotReachViewWithStr:(id)error
{
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        
        self.noreachView  =[[NotReachView alloc] init];
        self.noreachView.error = error;
        self.noreachView.ReloadButtonBlock=^{
            [weakSelf getServerData];
        };
        [self.view addSubview: self.noreachView];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - server methods
-(void)getServerData
{
    
  
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];

        [HomeDataTool getHomeDataWithUrl:@"/home/data" success:^(id obj) {
        
                [hud hide:YES];
                self.contentDict =obj;
                [self createMainView];
            //根据返回的登录状态和购物车参数来处理显示购物车图标数量
            
            
         
        } failure:^(id obj) {
        
                [hud hide:YES];
                [self createNotReachViewWithStr:obj];
        
            
        }];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            //获取刷新提示的语句得到保存到缓存中
            [HomeDataTool getsomeThing:@"/ana" success:^(id obj) {
                NSDictionary * dict =[obj objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:dict.allValues forKey:@"someThing"];
            } failure:^(id obj) {
                nil;
            }];
            
            
            //获取一次用户信息
            [UserInfoTool userInfo:@"/user/info" params:nil success:^(id obj) {
             //更新本地用户信息
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:obj];
                [dict setObject:[obj objectForKey:@"user_name"] forKey:@"name"];
                NSMutableData* data = [[NSMutableData alloc]init];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:dict forKey:@"userInfoModel"];
                [archiver finishEncoding];
                [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfoModel"];
            } failure:^(id obj) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                        //清除session
                        [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
                    }
                }

            }];

        });
    });
}
#pragma mark - private methods

//搜索和扫码功能
-(void)searchAndERWeiMa
{
   
}
/**
 跳转到活动页面
 */
-(void)presentToActivityView:(NSString*)action andParam:(NSString*)param
{
    if ([action isEqualToString:@"url"]) {
        ActivityViewController * activityVC  =[[ActivityViewController alloc] init];
        activityVC.url = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"goods_detail"]) {
        MaskDetailViewController * activityVC  =[[MaskDetailViewController alloc] init];
        activityVC.good_id = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"post_index"]) {
        [self.tabBarController setSelectedIndex:1];
    }
    if ([action isEqualToString:@"post_category"]) {
        CommunityListViewController * activityVC  =[[CommunityListViewController alloc] init];
        activityVC.post_id = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"post_detail"]) {
        CommeunityDetailViewController * activityVC  =[[CommeunityDetailViewController alloc] init];
        activityVC.post_id = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"help_index"]) {
        HelpViewController * activityVC  =[[HelpViewController alloc] init];
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"help_category"]) {
        HelpNextViewController * activityVC  =[[HelpNextViewController alloc] init];
        activityVC.post_id = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"help_detail"]) {
        HelpDeatilViewController * activityVC  =[[HelpDeatilViewController alloc] init];
        activityVC.post_id = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
}
-(void)loading
{
   
    [self getServerData];
  
}
-(void)loadMoreData
{
    [_mainTabelView.mj_footer endRefreshing];
}
#pragma mark- UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    __WEAK_SELF_YLSLIDE

   if(indexPath.section==0)
   {
       CarouselTableViewCell * CarouselCell  =[tableView dequeueReusableCellWithIdentifier:@"CarouselCell"];
       if(CarouselCell == nil)
       {
           CarouselCell =[[CarouselTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarouselCell"];
       }
       CarouselCell.sliderArr = [self.contentDict objectForKey:@"slider"];
       CarouselCell.CarouselCellBlock=^(NSString *action, NSString *param) {
            [weakSelf presentToActivityView:action andParam:param];
       };
       
     
       return CarouselCell;
   }
    if(indexPath.section==1)
    {
        FuncationTableViewCell * functionCell  =[tableView dequeueReusableCellWithIdentifier:@"functionCell"];
        if(functionCell == nil)
        {
            functionCell =[[FuncationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"functionCell"];
        }
        functionCell.funcationArray = [self.contentDict objectForKey:@"index_nav"];
        functionCell.CarouselCellBtnBlcok=^(NSString *action, NSString *param) {
              [weakSelf presentToActivityView:action andParam:param];
        };
   
        return functionCell;
    }
    
    if(indexPath.section ==2)
    {
        EventTableViewCell * evenCell  =[tableView dequeueReusableCellWithIdentifier:@"evenCell"];

        if(evenCell == nil)
        {
            evenCell =[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"evenCell"];
        }
        evenCell.actionArr= [self.contentDict objectForKey:@"index_ad_hot"];
        evenCell.ActionBlock =^(NSString *action, NSString *param) {
              [weakSelf presentToActivityView:action andParam:param];
        };
    
        return evenCell;
        
    }
   if(indexPath.section ==3)
   {

       ClassifyTableViewCell * classCell =[tableView dequeueReusableCellWithIdentifier:@"classCell"];
       if(classCell  == nil)
       {
           classCell  =[[ClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classCell"];
       
       }
       classCell.actionArray =[self.contentDict objectForKey:@"index_ad_com"];
       classCell.ClassifyTableViewCellOneBlock=^(NSString *action, NSString *param) {
             [weakSelf presentToActivityView:action andParam:param];
       };
       classCell.ClassifyTableViewCellTwoBlock=^(NSString *action, NSString *param) {
             [weakSelf presentToActivityView:action andParam:param];
       };
       
       
       [classCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
       return classCell;
    }
    
   if(indexPath.section ==4)
    {
        AdvertisementTableViewCell * adverCell  =[tableView dequeueReusableCellWithIdentifier:@"advercell"];

        if(adverCell == nil)
        {
            adverCell =[[AdvertisementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"advercell"];
        }
        adverCell.actionArray =[self.contentDict objectForKey:@"index_ad_com"];
        [adverCell advertisementClick:^(NSString *action, NSString *param) {
              [weakSelf presentToActivityView:action andParam:param];
        }];
 
        
        return adverCell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return kScreenWidth/2;
    else if(indexPath.section==1)
        return kScreenWidth/2.3;
    else if(indexPath.section==2)
        return (kScreenWidth/2-9.5)*0.955+14;
    else if(indexPath.section==3)
    {
        
        CGFloat height = [self.mainTabelView cellHeightForIndexPath:indexPath model:[self.contentDict objectForKey:@"index_ad_com"] keyPath:@"actionArray" cellClass:[ClassifyTableViewCell class] contentViewWidth:kScreenWidth];
        return height;
    }
   
    else
        return (kScreenWidth-14)/5+35;
}


#pragma mark - 内存警告
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

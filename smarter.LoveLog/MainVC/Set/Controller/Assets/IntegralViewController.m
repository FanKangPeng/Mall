//
//  IntegralViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "IntegralViewController.h"
#import "BalanceTableViewCell.h"
#import "UserInfoTool.h"
#import "HelpViewController.h"
@interface IntegralViewController ()
@property(nonatomic,strong)NotReachView * noreachView;

@end

@implementation IntegralViewController
#pragma mark - life Cycle
-(void)viewWillAppear:(BOOL)animated
{
    if (_noreachView || _listView ) {
        [self getData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:@"我的积分" andBack:@"icon_back.png" andRightName:@"帮助"];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    setNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf.lcNavigationController pushViewController:[[HelpViewController alloc] init]];
    };
    [self.view addSubview:setNavigationView];
    [self getData];
    // Do any additional setup after loading the view.
}
#pragma mark - initView
-(void)initFailView:(id)error
{
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getData];
        };
        [self.view addSubview:_noreachView];
    }
}
-(void)initView
{
    if(!_listView)
    {
        [self.view addSubview:self.listView];
    }
    else
    {
        [self.listView.mj_footer endRefreshing];
        [self.listView reloadData];
    }
    if(!_headerView)
    {
        [self.view addSubview:self.headerView];
    }
    else
    {
        [_headerView removeFromSuperview];
        _headerView  =nil;
        [self.view addSubview:self.headerView];
    }
}
-(void)removeView
{
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
}

#pragma mark - server method
-(void)getData
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    [UserInfoTool userInfo:@"/user/point" params:nil success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.contentDict =[NSDictionary dictionaryWithDictionary:obj];
       
        [self initView];
        
    } failure:^(id obj) {
        [hud hide:YES];
        [self removeView];
        [self initFailView:obj];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err =obj;
            if ([[err.userInfo objectForKey:@"NSLocalizedDescription"]isEqualToString:@"暂无数据"]) {
               
            }
            else
                [self initFailView:obj];

        }
        else
        {
            
           if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]])  {
                 [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
               
            }
            else
            {
              HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
        }

    }];
}


#pragma mark -  UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

     return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [self.contentDict objectForKey:@"list"];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView   =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    UILabel * headTitle = [[UILabel alloc] initWithFrame:CGRectMake(KLeft, KLeft, kScreenWidth, KLeft*2)];
    headTitle.text= @"收支明细";
    headTitle.font = DefaultFontSize(15);
    headTitle.textColor = FontColor_black;
    [headView addSubview:headTitle];
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        BalanceTableViewCell * balanceCell =[tableView dequeueReusableCellWithIdentifier:@"balanceCell"];
        if (balanceCell==nil) {
            balanceCell =[[BalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"balanceCell"];
        }
        NSArray * array =[self.contentDict objectForKey:@"list"];
        IncomeAndExpenditures * incomemodel =[IncomeAndExpenditures mj_objectWithKeyValues:array[indexPath.row]];
        balanceCell.IncomeAndExpenditures =incomemodel;
        return balanceCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSArray * array =[self.contentDict objectForKey:@"list"];
        IncomeAndExpenditures * incomeAndExpenditures = [IncomeAndExpenditures mj_objectWithKeyValues:array[indexPath.row]];
        
        CGFloat height =[self.listView  cellHeightForIndexPath:indexPath model:incomeAndExpenditures keyPath:@"IncomeAndExpenditures" cellClass:[BalanceTableViewCell class] contentViewWidth:kScreenWidth];
        return  height;
  
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark -  setter and getter
-(IntegralHeaderView *)headerView
{
    if (!_headerView) {
        _headerView =[[IntegralHeaderView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, 230)];
        _headerView.moneyDict = @{@"allMoney":[self.contentDict objectForKey:@"rank_points"],@"help_url":[self.contentDict objectForKey:@"help_url"]};
    }
    return _headerView;
}
-(UITableView *)listView
{
    if (!_listView) {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, 230+kNavigationHeight+KLeft, kScreenWidth, kScreenHeight-(230+kNavigationHeight+KLeft)) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        
        
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_listView setTableFooterView:view];
    }
    return _listView;
}
@end

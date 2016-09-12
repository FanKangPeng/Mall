//
//  MoneyViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MoneyViewController.h"
#import "UserInfoTool.h"
#import "BalanceTableViewCell.h"
#import "IncomeAndExpenditures.h"
#import "HelpViewController.h"
@interface MoneyViewController ()
@property(nonatomic,strong)NotReachView * noreachView;

@end

@implementation MoneyViewController
#pragma mark -- life Cycle
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
    [setNavigationView initViewWithTitle:@"我的钱包" andBack:@"icon_back.png" andRightName:@"帮助"];
    __WEAK_SELF_YLSLIDE
    setNavigationView .CustomNavigationLeftImageBlock=^{
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
        _noreachView  =[[NotReachView alloc] init];
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
    if(!_headView)
    {
        [self.view addSubview:self.headView];
    }
    else
    {
        [_headView removeFromSuperview];
        _headView  =nil;
        [self.view addSubview:self.headView];
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
    [UserInfoTool userInfo:@"/user/money" params:nil success:^(id obj) {
        [self removeView];
        [hud hide:YES];
        self.contentDict =[NSDictionary dictionaryWithDictionary:obj];
       
        [self initView];
        
    } failure:^(id obj) {
        [self removeView];
        [hud hide:YES];
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
        
        [self initFailView:obj];
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
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
        
        CGFloat height =[self.listView cellHeightForIndexPath:indexPath model:incomeAndExpenditures keyPath:@"IncomeAndExpenditures" cellClass:[BalanceTableViewCell class]  contentViewWidth:kScreenWidth];
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
#pragma mark - setter and getter
-(MoneyHeaderView *)headView
{
    if (!_headView) {
        _headView =[[MoneyHeaderView alloc] initWithFrame:CGRectMake(0, kNavigationHeight+KLeft, kScreenWidth, 100)];
        [_headView setBackgroundColor:[UIColor whiteColor]];
        _headView.moneyDict =@{@"allMoney":[self.contentDict objectForKey:@"total_money"],@"ableBalance":[self.contentDict objectForKey:@"user_money"],@"withdrawBalance":[self.contentDict objectForKey:@"frozen_money"],@"help_url":[self.contentDict objectForKey:@"help_url"]};
        
    }
    return _headView;
}
-(UITableView *)listView
{
    if (!_listView) {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, 110+kNavigationHeight+KLeft, kScreenWidth, kScreenHeight-(110+kNavigationHeight+KLeft)) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        

        
        [_listView setTableFooterView:view];
    }
    return _listView;
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

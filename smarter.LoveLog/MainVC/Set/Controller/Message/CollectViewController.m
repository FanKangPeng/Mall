//
//  CollectViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/23.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "CollectViewController.h"
#import "UserInfoTool.h"
@implementation CollectViewController

#pragma mark - life Cycle
-(void)viewDidLoad
{
    //添加导航view
    CustomNavigationView* NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    
    [NavigationView initViewWithTitle:@"我的收藏" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:NavigationView];
    
    [self.view addSubview:self.titleView];
    [self getData];
    
}
#pragma mark - initView
-(void)removeView
{
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(_noDataView)
    {
        [_noDataView removeFromSuperview];
        _noDataView= nil;
    }
}
-(void)initView
{
    
    
    if(!_collectionTableView)
    {
        [self.view addSubview:self.collectionTableView];
    }
    else
    {
        [self.collectionTableView.mj_footer endRefreshing];
        [self.collectionTableView.mj_header endRefreshing];
        [self.collectionTableView reloadData];
    }
}
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
-(void)initNodataView
{
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight)];
        //_noDataView.CAPION =@"暂无相应的收藏信息";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [self.view addSubview:_noDataView];
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
    [UserInfoTool getCollect:@"/user/collect/list" params:nil success:^(id obj) {
        [self removeView];
        [hud hide:YES];
        [self initNodataView];
//        [self initView];
//         [self initFailView:obj];
    } failure:^(id obj) {
        [hud hide: YES];
        [self removeView];
        if ([obj isKindOfClass:[NSError class]]) {
            
            NSError * err =obj;
            if ([[err.userInfo  objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
                [self initNodataView];
            }
            else
                [self initFailView:obj];
            
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            [self initFailView:obj];
            
        }

    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
#pragma mark - private method


//titleView button click
-(void)buttonClick:(UIButton*)button
{
    if (button.tag != _titleTag) {
        _titleTag = button.tag;
        _titleLine.center = CGPointMake(button.center.x, kBottomBarHeight-1) ;
//        //通过这样设置 让每次切换数据后的tableview均处于最初状态  期待更好方法
//        if(self.collectionTableView)
//        {
//            [self.collectionTableView removeFromSuperview];
//            self.collectionTableView = nil;
//            [self.view addSubview:self.collectionTableView];
//        }
    }
    
}

#pragma mark - setter and getter

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kBottomBarHeight)];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray * titleName = @[@"产品",@"帖子",@"文章"];
        for (int i =0 ; i <titleName.count; i++) {
            UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.left = kScreenWidth/3*i;
            titleButton.top = 0;
            titleButton.width= kScreenWidth/3;
            titleButton.height = kBottomBarHeight-1;
            [titleButton setTitle:titleName[i] forState:UIControlStateNormal];
            [titleButton setTitleColor:FontColor_black forState:UIControlStateNormal];
            titleButton.titleLabel.font = DefaultFontSize(15);
            [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            titleButton.tag = 100+ i;
            [_titleView addSubview:titleButton];
            
            if (i !=2) {
                UILabel * shuxian  =[UILabel new];
                [shuxian setBackgroundColor:ShiXianColor];
                [_titleView addSubview:shuxian];
                shuxian.sd_layout
                .leftSpaceToView(titleButton,-SINGLE_LINE_WIDTH)
                .topSpaceToView(_titleView,15)
                .heightIs(20)
                .widthIs(SINGLE_LINE_WIDTH);
            }
            
            if (i == 0) {
                _titleTag = titleButton.tag;
                [_titleView addSubview:self.titleLine];
                
                _titleLine.center = CGPointMake(titleButton.center.x, kBottomBarHeight-1) ;
            }
            
        }
        
    }
    return _titleView;
}
-(UITableView *)collectionTableView
{
    if (!_collectionTableView) {
        _collectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight- kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
        _collectionTableView.delegate =self;
        _collectionTableView.dataSource =self;
        UIView * tableViewFootView = [ UIView new];
        [tableViewFootView setBackgroundColor:[UIColor clearColor]];
        _collectionTableView.tableFooterView = tableViewFootView;
        if([_collectionTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_collectionTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_collectionTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_collectionTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
    }
    return _collectionTableView;
}
-(UIView *)titleLine
{
    if (!_titleLine) {
        _titleLine = [UIView new];
        [_titleLine setBackgroundColor:NavigationBackgroundColor];
        _titleLine.height = 1;
        _titleLine.width = kNavigationHeight;
        
    }
    return _titleLine;
}
@end


//
//  NotificationViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "UserInfoTool.h"
#import "NotificationModel.h"
@interface NotificationViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@end

@implementation NotificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_noDataView||_noreachView||_listView) {
        [self getData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:@"我的通知" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:setNavigationView];
    _pageCount=1;
    [self getData];
}
-(void)getData
{
    [_noDataView.mj_header endRefreshing];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [UserInfoTool getMessage:@"/message/notice" params:nil success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.messageDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSArray * array =[self.messageDict objectForKey:@"message"];
        if (array) {
            [self initView];
        }
        else
            [self initNodataView];
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

-(void)initView
{

    
    if(!_listView)
    {
        [self.view addSubview:self.listView];
    }
    else
    {
        [self.listView.mj_footer endRefreshing];
        [self.listView.mj_header endRefreshing];
        [self.listView reloadData];
    }
}
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
-(void)initNodataView
{
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
        _noDataView.CAPION =@"暂无通知信息";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [self.view addSubview:_noDataView];
    }
}

-(void)listLoadMore
{
 
    NSNumber * allCount = [[self.messageDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        NSDictionary * dict=@{@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
        
        
        [UserInfoTool getMessage:@"/message/notice" params:dict success:^(id obj) {
            NSMutableArray * messageArr =[self.messageDict objectForKey:@"message"];
            [messageArr addObjectsFromArray:[obj objectForKey:@"message"]];
            
            [self.messageDict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [self.messageDict setObject:messageArr forKey:@"message"];
            
            [self initView];
        } failure:^(id obj) {
            _pageCount--;
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * err =  obj;
                HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            [self.listView.mj_footer endRefreshing];

        } ];
    }
    else
    {
        
            HUDSHOW(@"没有更多了...");
        [self.listView.mj_footer endRefreshing];
    }
}
-(void)listReloadData
{
    [self getData];
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_listView setTableFooterView:view];
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(listReloadData)];
        _listView.mj_footer =[CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(listLoadMore)];
        
    }
    return _listView;
}

#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array =[self.messageDict objectForKey:@"message"];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[NotificationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    NSArray * array =[self.messageDict objectForKey:@"message"];
    cell.model = array[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}
-(void)buttonClick:(UIButton*)button
{
    if(button.selected)
        button.selected=NO;
    else
        button.selected =YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSArray * array =[self.messageDict objectForKey:@"message"];
    CGFloat  height =[self.listView  cellHeightForIndexPath:indexPath model:array[indexPath.row] keyPath:@"model" cellClass:[NotificationCell class]  contentViewWidth:kScreenWidth];
    return height;
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


@end

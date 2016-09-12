//
//  OrderListViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "OrderDeatilViewController.h"
#import "UserInfoTool.h"
#import "PayViewController.h"
@interface OrderListViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@end

@implementation OrderListViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (_noDataView||_noreachView ||_OrderList) {
        [self getPostsDataWithType];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加导航view
    NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    
    [NavigationView initViewWithTitle:self.title andBack:@"icon_back.png" andRightName:@""];
     __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    
//    NavigationView.CustomNavigationCustomRightBtnBlock=^{
//        //
//        [weakSelf searchButtonClick];
//        
//    };
  
    [self.view addSubview:NavigationView];
    _dataArray =[NSMutableArray array];
    _resultsData =[NSMutableArray array];
    type= [_typeString isEqual:nil] ? @"1" : _typeString;
    topHeight = kNavigationHeight;
    _pageCount=1;
    [self initTitleView];
    [self getPostsDataWithType];
    
}
-(void)initTitleView
{
    if(!_titleList)
    {
        if(self.isShowTitle)
        {
            [self.view addSubview:self.titleList];
            topHeight = _titleList.bottom;
        }
    
    }
}

-(void)initView
{
    
    
    if(!_OrderList)
    {
        
        [self.view addSubview:self.OrderList];
       
    }
    else
    {
        [self.OrderList.mj_footer endRefreshing];
        [self.OrderList.mj_header endRefreshing];
        [self.OrderList reloadData];
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
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0, topHeight, kScreenWidth, kScreenHeight-topHeight)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getPostsDataWithType];
        };
        [self.view addSubview:_noreachView];
    }
}
-(void)initNodataView
{
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, topHeight, kScreenWidth, kScreenHeight-topHeight)];
        _noDataView.CAPION =@"您没有相关的订单";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPostsDataWithType)];
        [self.view addSubview:_noDataView];
    }
}
//获取订单列表
-(void)getPostsDataWithType
{
    [_noDataView.mj_header endRefreshing];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    NSString * typeStr =@"all";
    switch ([type intValue]) {
        case 1:
            typeStr =@"all";
            break;
        case 2:
            typeStr =@"await_pay";
            break;
        case 3:
            typeStr =@"await_ship";
            break;
        case 4:
            typeStr =@"shipped";
            break;
        case 5:
            typeStr =@"await_cmt";
            break;
        case 6:
            typeStr =@"finished";
            break;
            
        default:
            break;
    }
    
    
    [UserInfoTool getOrder:@"/order/list" params:@{@"type":typeStr} success:^(id obj) {
         [hud hide:YES];
        self.orderDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [self removeView];
        _dataArray = [NSMutableArray arrayWithArray: [self.orderDict objectForKey:@"ordermodel"]];
        if (_dataArray.count == 0) {
            [self initNodataView];
        }
        else
            [self initView];
    } failure:^(id obj) {
        [hud hide:YES];
        [self removeView];
        if ([obj isKindOfClass:[NSError class]]) {
            
            NSError * err =obj;
            if ([[err.userInfo objectForKey:@"NSLocalizedDescription"]isEqualToString:@"暂无数据"]) {
                [self initNodataView];
            }
            else
                [self initFailView:obj];
            
            
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
              
            }
            [self initFailView:obj];
        }
    }];
}
//取消订单
-(void)cancelOrder:(NSString*)order_id
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [UserInfoTool userInfo:@"/order/cancel" params:@{@"order_id":order_id} success:^(id obj) {
        [hud hide:YES];
        [self getPostsDataWithType];
    } failure:^(id obj) {
            [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            
            
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
               [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            
        }
    }];
}
//确认收货
-(void)receivedOrder:(NSString*)order_id
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    [UserInfoTool userInfo:@"/order/affirmReceived" params:@{@"order_id":order_id} success:^(id obj) {
            [hud hide:YES];
         [self getPostsDataWithType];
    } failure:^(id obj) {
            [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            
        }
    }];
}
//订单支付
-(void)payOrder:(NSString*)order_id
{
    PayViewController * pay =[[PayViewController alloc] init];
    pay.order_id =order_id;
    
    [self.lcNavigationController pushViewController:pay];
}
-(UITableView *)OrderList
{
    if(!_OrderList)
    {
      
        _OrderList =[[UITableView alloc] initWithFrame:CGRectMake(0,topHeight, kScreenWidth, kScreenHeight-topHeight) style:UITableViewStylePlain];
        _OrderList.delegate =self;
        _OrderList.dataSource =self;
        [_OrderList setBackgroundColor:BackgroundColor];
        _OrderList.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.OrderList.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.OrderList.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(listReloadData)];
        
        
    }
    return _OrderList;
}
-(void)listReloadData
{
    [_OrderList reloadData];
    [_OrderList.mj_header endRefreshing];
}
-(UISearchController *)mySearchController
{
    if(!_mySearchController)
    {
        _mySearchController =[[UISearchController alloc] initWithSearchResultsController:nil];
        _mySearchController.searchResultsUpdater =self;
        _mySearchController.searchBar.placeholder=@"搜索帖子/用户名";
        [_mySearchController.searchBar setTintColor:[UIColor blackColor]];
        _mySearchController.searchBar.delegate=self;
        _mySearchController.dimsBackgroundDuringPresentation = NO;
        _mySearchController.hidesNavigationBarDuringPresentation = NO;
        _mySearchController.searchBar.frame = CGRectMake(self.mySearchController.searchBar.frame.origin.x, self.mySearchController.searchBar.frame.origin.y, self.mySearchController.searchBar.frame.size.width, 44.0);
    }
    
    return _mySearchController;
}
-(void)searchButtonClick
{
    self.OrderList.tableHeaderView = self.mySearchController.searchBar;
    self.OrderList.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-20);
    [self.mySearchController.searchBar becomeFirstResponder];
}

-(void)loadNewData
{
    NSNumber * allCount = [[self.orderDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        
        
        NSString * typeStr =@"all";
        switch ([type intValue]) {
            case 1:
                typeStr =@"all";
                break;
            case 2:
                typeStr =@"await_pay";
                break;
            case 3:
                typeStr =@"await_ship";
                break;
            case 4:
                typeStr =@"shipped";
                break;
            case 5:
                typeStr =@"await_cmt";
                break;
            case 6:
                typeStr =@"finished";
                break;
                
            default:
                break;
        }
        
        
        [UserInfoTool getOrder:@"/order/list" params:@{@"type":typeStr,@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}} success:^(id obj) {
            
            NSMutableArray * communityArr =[self.orderDict objectForKey:@"ordermodel"];
            [communityArr addObjectsFromArray:[obj objectForKey:@"ordermodel"]];
            
            [self.orderDict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [self.orderDict setObject:communityArr forKey:@"ordermodel"];
            
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
            
            [self.OrderList.mj_footer endRefreshing];
        }];
    }
    else
    {
            HUDSHOW(@"没有更多了...");
        [self.OrderList.mj_footer endRefreshing];
    }
    

}
-(UIView *)titleList
{
    if(!_titleList)
    {
        _titleList =[[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kBottomBarHeight+SINGLE_LINE_WIDTH)];
        [_titleList setBackgroundColor:[UIColor whiteColor]];
        NSArray * labelTexts =@[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
        for (int i = 0; i<labelTexts.count; i++)
        {
            UIButton * button  =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(kScreenWidth/5 * i,0, kScreenWidth/5,kBottomBarHeight);
            [button setTitleColor:FontColor_gary forState:UIControlStateNormal];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateHighlighted];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateSelected];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button.titleLabel setFont:DefaultFontSize(13)];
            [button setTitle:[NSString stringWithFormat:@"%@",labelTexts[i]] forState:UIControlStateNormal];
            button.tag = 100+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            [_titleList addSubview:button];
            
            if(i==0)
            {
                redLine =[[UILabel alloc] initWithFrame:CGRectMake(10, kBottomBarHeight-SINGLE_LINE_WIDTH, kScreenWidth/5-20, SINGLE_LINE_WIDTH)];
                [redLine setBackgroundColor:NavigationBackgroundColor];
                [self.titleList addSubview:redLine];
                
                _buttonTag = button.tag;
                button.selected =YES;
            }
            
            
            UILabel * shuxian  =[[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width * i -SINGLE_LINE_WIDTH, _titleList.frame.size.height/2-10, SINGLE_LINE_WIDTH, 20)];
            [shuxian setBackgroundColor:ShiXianColor];
            [_titleList addSubview:shuxian];
            
        }
        
        UILabel * hengline =[[UILabel alloc] initWithFrame:CGRectMake(0, kBottomBarHeight, kScreenWidth, SINGLE_LINE_WIDTH)];
        [hengline setBackgroundColor:ShiXianColor];
        [_titleList addSubview:hengline];
    }
    return _titleList;
}
-(void)buttonClick:(UIButton*)button
{
    if(button.tag !=_buttonTag)
    {
        UIButton * lastButton =(UIButton*)[self.titleList viewWithTag:_buttonTag];
        lastButton.selected=NO;
        button.selected=YES;
        redLine.frame = CGRectMake(button.frame.origin.x+10, kBottomBarHeight-SINGLE_LINE_WIDTH, kScreenWidth/5-20, SINGLE_LINE_WIDTH);
        
        //通过这样设置 让每次切换数据后的tableview均处于最初状态  期待更好方法
        if(self.OrderList)
        {
            [self.OrderList removeFromSuperview];
            self.OrderList = nil;
            [self.view addSubview:self.OrderList];
        }
      
    }

    
    
    _buttonTag=button.tag;
    NSUInteger xxx =_buttonTag-99;
    type=[NSString stringWithFormat:@"%ld",(long)xxx];
    
    [self getPostsDataWithType];
}

#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.mySearchController.searchBar.showsCancelButton = YES;
    
    NSArray *subViews;
    
    
    subViews = self.mySearchController.searchBar.subviews;
    
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //  searchBar.showsCancelButton = NO;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態
    [UIView animateWithDuration:0.3f animations:^{
       
        self.OrderList.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-20);
    
        [searchBar setTintColor:[UIColor whiteColor]];
        [NavigationView initViewWithTitle:@"" andBack:@"" andRightName:@""];
        
    }];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    [UIView animateWithDuration:0.3f animations:^{
        [NavigationView initViewWithTitle:@"订单列表" andBack:@"icon_back.png" andRightName:@"搜索"];
        if([self isShowTitle])
        {
            self.OrderList.frame = CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight);
        }
        else
            self.OrderList.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight);
        
    }];
    self.OrderList.tableHeaderView = nil;
    [searchBar removeFromSuperview];
    [searchBar resignFirstResponder];
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if(searchController.searchBar.text.length>0)
        [self filterContentForSearchText:_mySearchController.searchBar.text
                               scope:[_mySearchController.searchBar scopeButtonTitles][_mySearchController.searchBar.selectedScopeButtonIndex]];
}


//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _dataArray.count; i++) {
        OrderModel  * model = _dataArray[i];
        NSString *storeString =@"";
        for (NSDictionary * dddd  in model.goods_list) {
            storeString = [storeString stringByAppendingString:[dddd objectForKey:@"name"]];
        }
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:model];
        }
    }
    
    [_resultsData removeAllObjects];
    [_resultsData addObjectsFromArray:tempResults];
    
    [self.OrderList reloadData];
}




#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mySearchController.active)
    {
        tableView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
        
        //解决上面空出的20个像素
        self.edgesForExtendedLayout = UIRectEdgeNone;
        return _resultsData.count;
    }
    else
    {
        return _dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel * communityModel =[[OrderModel alloc] init] ;
   
    
    if (_mySearchController.active)
    {
        communityModel = _resultsData[indexPath.row];
    }
    else
        communityModel =_dataArray[indexPath.row];
    
    OrderCell * orderCell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (orderCell == nil) {
        orderCell =[[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    orderCell.orderModel = communityModel;
    orderCell.OrderCellBlock = ^(NSInteger index,NSString*order_id){
        switch (index) {
                            case 0:
                                [self cancelOrder:order_id];
                                break;
                            case 1:
                                [self payOrder:order_id];
                                break;
                            case 2:
                                [self receivedOrder:order_id];
                                break;
                                
                            default:
                                break;
                        }
    };


    [orderCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
  
    
    return orderCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return  185;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_mySearchController.active)
    {
        _mySearchController.active= NO;
        [_mySearchController.searchBar removeFromSuperview];
        _OrderList.tableHeaderView = nil;
        //搜尋結束後，恢復原狀
        [UIView animateWithDuration:0.3f animations:^{
              [NavigationView initViewWithTitle:@"我的订单" andBack:@"icon_back.png" andRightName:@"搜索"];
            if([self isShowTitle])
            {
                self.OrderList.frame = CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight);
            }
            else
                self.OrderList.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight);

            [_OrderList reloadData];
        }];

    }
    
    [self.lcNavigationController pushViewController:[[OrderDeatilViewController alloc] init]];
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

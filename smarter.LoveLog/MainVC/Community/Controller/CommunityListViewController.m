//
//  CommunityListViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityListViewController.h"
#import "CommunityTableViewCell.h"
#import "CommeunityDetailViewController.h"
#import "CommunityModel.h"
#import "CommunityTool.h"
#import "CommentListViewController.h"
@interface CommunityListViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@end

@implementation CommunityListViewController
#pragma mark - Life Cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_communityDict) {
        [self getCommunityListData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CommunityNavigationView =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [CommunityNavigationView initViewWithTitle:@"帖子列表" andBack:@"icon_back.png" andRightName:@"发布"];
    __WEAK_SELF_YLSLIDE
    CommunityNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //
        
    };
    CommunityNavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:CommunityNavigationView];
    
    _pageCount=1;
    
    [self getCommunityListData];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - server methods

-(void)getCommunityListData
{
    NSDictionary * dict =@{@"id":self.post_id};
    
    
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView =[[LoadGIF_M alloc] init];
    [hud show:YES];
    [CommunityTool getCommunityListDate:@"/post/category" params:dict success:^(id obj) {
        [hud hide:YES];
        self.communityDict  =[NSMutableDictionary dictionaryWithDictionary:obj];
    } failure:^(id obj) {
        [hud hide:YES];
        self.error = obj;
    }];
}
-(void)loadMore
{
    NSNumber * allCount = [[self.communityDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        NSDictionary * dict=@{@"id":self.post_id,@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
        
        
        [CommunityTool getCommunityMoreDate:@"/post/category" params:dict success:^(id obj) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.communityDict];
            NSMutableArray * communityArr =[dict objectForKey:@"promote_posts"];
            [communityArr addObjectsFromArray:[obj objectForKey:@"promote_posts"]];
            
            [dict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [dict setObject:communityArr forKey:@"promote_posts"];
            
            self.communityDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            if (self.listView.mj_footer.isRefreshing) {
                [self.listView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            _pageCount--;
            HUDSHOW(@"刷新失败");
            if (self.listView.mj_footer.isRefreshing) {
                  [self.listView.mj_footer endRefreshing];
            }
          
        }];
    }
    else
    {
        
        HUDSHOW(@"没有更多了...");
        if (self.listView.mj_footer.isRefreshing) {
            [self.listView.mj_footer endRefreshing];
        }
    }
    
    
}
#pragma mark - private methods
#pragma mark - UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //searchDisplayController自身有一个searchResultsTableView，所以在执行操作的时候首先要判断是否是搜索结果的tableView，如果是显示的就是搜索结果的数据，如果不是，则显示原始数据。
    
    if(isActive)
    {
        tableView.top = 20;
        tableView.height = kScreenHeight -20;
        
        //解决上面空出的20个像素
        self.edgesForExtendedLayout = UIRectEdgeNone;
        return _resultsData.count;
    }
    else
    {
        NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
        return array.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  height;
    if(isActive)
    {
        height = [_listView cellHeightForIndexPath:indexPath model:_resultsData[indexPath.section] keyPath:@"communityModel" cellClass:[CommunityTableViewCell class] contentViewWidth:kScreenWidth];
        
    }
    else
    {
        NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
        height = [_listView cellHeightForIndexPath:indexPath model:array[indexPath.section] keyPath:@"communityModel" cellClass:[CommunityTableViewCell class] contentViewWidth:kScreenWidth];
    }
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * communityModel =[[CommunityModel alloc] init] ;
    
    
    if (isActive)
    {
        communityModel = _resultsData[indexPath.section];
    }
    else
    {
        NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
        communityModel =array[indexPath.section];
    }
    
    
    static NSString *cellStr = @"CommunityListTableViewCell";
    
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if(!cell){
        
        cell = [[CommunityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.tag = indexPath.section;
    cell.communityModel = communityModel;
    
    cell.commentBlock =  ^(NSString * community_id){
        CommentListViewController * vc =[[CommentListViewController alloc] init];
        vc.post_id = community_id;
        [self.lcNavigationController pushViewController:vc];
    };
    
    cell.commentLoginBlock  = ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
    };
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommunityModel * model ;
    if(isActive)
    {
        _mySearchController.active=NO;
        isActive = NO;
        [_mySearchController.searchBar removeFromSuperview];
        model = _resultsData[indexPath.section];
        //搜尋結束後，恢復原狀
        [UIView animateWithDuration:0 animations:^{
            [CommunityNavigationView initViewWithTitle:@"帖子列表" andBack:@"icon_back.png" andRightName:@"发布"];
            _listView.top = kNavigationHeight;
            _listView.height = kScreenHeight - kNavigationHeight;
            [_listView reloadData];
        }];
        
    }
    else
    {
        NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
        model = array[indexPath.section];
    }
    CommeunityDetailViewController * commeunituDetailVC  =[[CommeunityDetailViewController alloc] init];
    commeunituDetailVC.post_id = model.id;
    [self.lcNavigationController pushViewController:commeunituDetailVC];
}
#pragma mark - UISearchBar and UISearchDisplayController Delegate Methods

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _mySearchController.searchBar.showsCancelButton = YES;
    isActive  = YES;
    NSArray *subViews;
    subViews = _mySearchController.searchBar.subviews;
    
    
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
        _listView.top  = 20;
        _listView.height = kScreenHeight -20;
        
        
        [searchBar setTintColor:[UIColor whiteColor]];
        [CommunityNavigationView initViewWithTitle:@"" andBack:@"" andRightName:@""];
        
    }];
    isActive  =  YES;
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
        [CommunityNavigationView initViewWithTitle:@"帖子列表" andBack:@"icon_back.png" andRightName:@"发布"];
        _listView.top = kNavigationHeight;
        _listView.height = kScreenHeight - kNavigationHeight;
        
    }];
    isActive  = NO;
    [self.listView reloadData];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     [self filterContentForSearchText:_mySearchController.searchBar.text];
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if(_mySearchController.searchBar.text.length <= 0)
    {
        isActive = NO;
        [self.listView reloadData];
    }

}


//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText
{
    _resultsData = [NSMutableArray array];
    isActive =  YES;
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
    for (int i = 0; i < array.count; i++) {
        CommunityModel  * model = array[i];
        NSString *storeString = model.brief;
        storeString  =[storeString stringByAppendingString:model.title];
        storeString  =[storeString stringByAppendingString:[model.user objectForKey:@"name"]];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.location != NSNotFound) {
            [tempResults addObject:model];
        }
    }
    
    [_resultsData removeAllObjects];
    [_resultsData addObjectsFromArray:tempResults];
    
    if(_resultsData.count <=0)
    {
        HUDSHOW(@"未查询到");
    }
    
    [self.listView reloadData];
    
}

#pragma mark - setter and getter
- (void)setError:(id)error
{
    _error = error;
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }
  
        self.noreachView.error =error;
        [self.view addSubview:self.noreachView];
}
- (void)setCommunityDict:(NSMutableDictionary *)communityDict
{
    _communityDict = communityDict;
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
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
- (NotReachView *)noreachView
{
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] init];
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getCommunityListData];
        };
    }
    return _noreachView;
}

-(UITableView *)listView
{
    if(!_listView)
    {
        _listView  =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStyleGrouped];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_listView setBackgroundColor:[UIColor clearColor]];
         _listView.tableHeaderView = self.mySearchController.searchBar;
        _listView.dataSource =self;
        _listView.delegate =self;
  
        self.listView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommunityListData)];
        self.listView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    return _listView;
}


-(UISearchController *)mySearchController
{
   if(!_mySearchController)
   {
       
       _mySearchController =[[UISearchController alloc] initWithSearchResultsController:nil];
       _mySearchController.searchResultsUpdater =self;
       _mySearchController.searchBar.placeholder=@"搜索帖子/用户名";
       [_mySearchController.searchBar setTintColor:[UIColor blackColor]];
        _mySearchController.hidesBottomBarWhenPushed =YES;
       _mySearchController.searchBar.delegate=self;
       _mySearchController.dimsBackgroundDuringPresentation = NO ;
       _mySearchController.hidesNavigationBarDuringPresentation = NO;
       _mySearchController.searchBar.frame = CGRectMake(self.mySearchController.searchBar.frame.origin.x, self.mySearchController.searchBar.frame.origin.y, self.mySearchController.searchBar.frame.size.width, 44.0);
   }
    
    return _mySearchController;
}



#pragma mark -内存警告


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

//
//  MyPostsViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MyPostsViewController.h"
#import "CommunityTool.h"
#import "PostsCell.h"
#import "CommunityModel.h"
#import "CommentListViewController.h"
#import "WritePostsViewController.h"
#import "CommeunityDetailViewController.h"
@interface MyPostsViewController ()

@end

@implementation MyPostsViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_noDataView||_noreachView ||_listView) {
        [self getPostsDataWithType];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"我的帖子" andBack:@"icon_back.png" andRightName:@"发贴"];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    NavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf writePostsButton:nil];
    };
    [self.view addSubview:NavigationView];

    type=@"1";
    _pageCount =1;
    [self initTitleView];
    [self getPostsDataWithType];

}
-(void)initTitleView
{
    
    if(_titleList)
    {
        [self.titleList removeFromSuperview];
        self.titleList = nil;
    }
    
    if(!_titleList)
    {
        [self.view addSubview:self.titleList];
    }
    
    if(!_writePostsButton)
    {
        [self.view  addSubview:self.writePostsButton];
        [self.view bringSubviewToFront:self.writePostsButton];
    }
}

-(void)initView
{
    
    if(!_listView)
    {
        [self.view addSubview:self.listView];
        [self.view sendSubviewToBack:self.listView];
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
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }
}
-(void)initFailView:(id)error
{

    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0, _titleList.bottom, kScreenWidth, kScreenHeight-_titleList.bottom)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getPostsDataWithType];
        };
        [self.view addSubview:_noreachView];
     [self.view sendSubviewToBack:_noreachView];
       
    }
}
-(void)initNodataView
{
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, _titleList.bottom, kScreenWidth, kScreenHeight-_titleList.bottom)];
        _noDataView.CAPION =@"暂未什么帖子，写一个吧";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPostsDataWithType)];
        [self.view addSubview:_noDataView];
         [self.view sendSubviewToBack:_noDataView];
    }
}
-(void)getPostsDataWithType
{
    [_noDataView.mj_header endRefreshing];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
   
    
    [CommunityTool getCommunityListDate:@"/user/post" params:@{@"type":type} success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.postsDict  = [NSMutableDictionary dictionaryWithDictionary:obj];
       NSMutableArray * array   =[NSMutableArray arrayWithArray: [self.postsDict objectForKey:@"promote_posts"]];
        if (array.count>0) {
            [self initView];
        }
        else
        {
            [self initNodataView];
        }
        
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
-(void)loadNewData
{
    NSNumber * allCount = [[self.postsDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        NSDictionary * dict=@{@"type":type,@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
        
        
        [CommunityTool getCommunityListDate:@"/user/post" params:dict success:^(id obj) {
            
            NSMutableArray * communityArr =[self.postsDict objectForKey:@"promote_posts"];
            [communityArr addObjectsFromArray:[obj objectForKey:@"promote_posts"]];
            
            [self.postsDict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [self.postsDict setObject:communityArr forKey:@"promote_posts"];
            
            [self initView];
        } failure:^(id obj) {
            _pageCount--;
            HUDSHOW(@"刷新失败");
            [self.listView.mj_footer endRefreshing];
        }];
    }
    else
    {
        
            HUDSHOW(@"没有更多了...");
        
        
        [self.listView.mj_footer endRefreshing];
    }

}


-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(KLeft, kNavigationHeight+kBottomBarHeight, kScreenWidth-KLeft*2, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        [_listView setBackgroundColor:BackgroundColor];
        _listView.showsVerticalScrollIndicator= NO;
        
      
         self.listView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.listView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPostsDataWithType)];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _listView;
}

-(UIView *)titleList
{
    if(!_titleList)
    {
        _titleList =[[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kBottomBarHeight+SINGLE_LINE_WIDTH)];
        [_titleList setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * hengline =[[UILabel alloc] initWithFrame:CGRectMake(0, kBottomBarHeight-SINGLE_LINE_WIDTH, kScreenWidth, SINGLE_LINE_WIDTH)];
        [hengline setBackgroundColor:ShiXianColor];
        [_titleList addSubview:hengline];
        
        
        NSString * str1 =[NSString stringWithFormat:@"已发布"];
        NSString * str2 =[NSString stringWithFormat:@"草稿箱"];
        NSArray * labelTexts =@[str1,str2];
        for (int i = 0; i<2; i++)
        {
            
            
            UIButton * button  =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(kScreenWidth/2 * i,0, kScreenWidth/2,kBottomBarHeight);
            [button setTitleColor:FontColor_gary forState:UIControlStateNormal];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateHighlighted];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateSelected];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button.titleLabel setFont:DefaultFontSize(15)];
            [button setTitle:[NSString stringWithFormat:@"%@",labelTexts[i]] forState:UIControlStateNormal];
            button.tag = 100-i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            [_titleList addSubview:button];
            
            if(i==[type intValue]-1)
            {
                redLine =[[UILabel alloc] initWithFrame:CGRectMake(button.center.x-50, kBottomBarHeight-SINGLE_LINE_WIDTH, 100, SINGLE_LINE_WIDTH)];
                [redLine setBackgroundColor:NavigationBackgroundColor];
                [self.titleList addSubview:redLine];
                
                _buttonTag = button.tag;
                button.selected =YES;
            }
            
            
            UILabel * shuxian  =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 -SINGLE_LINE_WIDTH, _titleList.frame.size.height/2-10, SINGLE_LINE_WIDTH, 20)];
            [shuxian setBackgroundColor:ShiXianColor];
            [_titleList addSubview:shuxian];
            
        }
        
     
    }
    return _titleList;
}
-(UIButton *)writePostsButton
{
    if (!_writePostsButton) {
        _writePostsButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _writePostsButton.frame =CGRectMake(kScreenWidth-54,kScreenHeight-54, 44,44);
        [_writePostsButton setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
     
        [_writePostsButton addTarget:self action:@selector(writePostsButton:) forControlEvents:UIControlEventTouchDown];

    }
    return _writePostsButton;
}
-(void)writePostsButton:(UIButton*)button
{
    WritePostsViewController * writeVC =[[WritePostsViewController alloc] init];
    writeVC.writeVCBlock=^{
        type=@"2";
        _pageCount =1;
        [self initTitleView];
        [self getPostsDataWithType];
    
    };
    
     UINavigationController * navigation =[[UINavigationController alloc] initWithRootViewController:writeVC];
    [self.lcNavigationController pushViewController:navigation];
}
-(void)buttonClick:(UIButton*)button
{
    if(button.tag !=_buttonTag)
    {
        UIButton * lastButton =(UIButton*)[self.titleList viewWithTag:_buttonTag];
        lastButton.selected=NO;
        button.selected=YES;
        redLine.frame = CGRectMake(button.center.x-50, kBottomBarHeight-SINGLE_LINE_WIDTH, 100, SINGLE_LINE_WIDTH);
        if(self.listView)
        {
            [self.listView removeFromSuperview];
            self.listView = nil;
            [self.view addSubview:self.listView];
            [self.view sendSubviewToBack:self.listView];
        }
        
    }
    _buttonTag=button.tag;
    NSUInteger xxx =_buttonTag-99;
    type=[NSString stringWithFormat:@"%ld",(long)xxx];
    
    [self getPostsDataWithType];
}
#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * array   =[NSMutableArray arrayWithArray: [self.postsDict objectForKey:@"promote_posts"]];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostsCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell =[[PostsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSMutableArray * array   =[NSMutableArray arrayWithArray: [self.postsDict objectForKey:@"promote_posts"]];
    CommunityModel * model = [CommunityModel mj_objectWithKeyValues:array[indexPath.row]];
    cell.communityModel = model;
    __WEAK_SELF_YLSLIDE
    cell.PostsCellBlock=^(NSString *post_id) {
        CommentListViewController * commentList =[[CommentListViewController alloc] init];
        commentList.post_id = post_id;
        [weakSelf.lcNavigationController pushViewController:commentList];
    };
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     NSMutableArray * array   =[NSMutableArray arrayWithArray: [self.postsDict objectForKey:@"promote_posts"]];
    CommunityModel * model = [CommunityModel mj_objectWithKeyValues:array[indexPath.row]];

    CGFloat height = [self.listView  cellHeightForIndexPath:indexPath model:model keyPath:@"communityModel" cellClass:[PostsCell class] contentViewWidth:kScreenWidth-KLeft*2];
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray * array   =[NSMutableArray arrayWithArray: [self.postsDict objectForKey:@"promote_posts"]];
    CommunityModel * model = [CommunityModel mj_objectWithKeyValues:array[indexPath.row]];
    CommeunityDetailViewController * detailVC =[[CommeunityDetailViewController alloc] init];
    detailVC.post_id =model.id;
    [self.lcNavigationController pushViewController:detailVC];
}

@end

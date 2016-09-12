//
//  CommunityViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityTableViewCell.h"
#import "CommunityListViewController.h"
#import "CommeunityDetailViewController.h"
#import "CommunityModel.h"
#import "CommunityTool.h"
#import "ActivityViewController.h"

#import "CommentListViewController.h"

#import "MaskDetailViewController.h"
#import "MessageListViewController.h"
#import "HelpViewController.h"
#import "HelpNextViewController.h"
#import "HelpDeatilViewController.h"
#import "WritePostsViewController.h"
#import "AFNetHttp.h"
@interface CommunityViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@end

@implementation CommunityViewController
#pragma mark - Life  Cycle



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_communityDict) {
        [self getCommunityViewData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * CommunityNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [CommunityNavigationView initViewWithTitle:@"膜范社区" andBack:@"" andRightName:@"发贴"];
     __WEAK_SELF_YLSLIDE
    CommunityNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //判断登录
        if (isLogin) {
            WritePostsViewController * writeVC = [[WritePostsViewController alloc] init];
            writeVC.writeVCBlock = ^{
                
            };
            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:writeVC];
            [weakSelf.lcNavigationController pushViewController:navc];
        }
        else
        {
          [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        }
    };
    [self.view addSubview:CommunityNavigationView];
    
    
    [self getCommunityViewData];

    // Do any additional setup after loading the view.
}
- (void)jieping
{
    self.view.frame = CGRectMake(0, 20, kScreenWidth, self.communityList.contentSize.height);
    self.communityList.height =self.communityList.contentSize.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.communityList.contentSize.width, self.communityList.contentSize.height), YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
}
#pragma mark - server methods
-(void)getCommunityViewData
{
    
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [CommunityTool getCommunityViewDate:@"/post/index" success:^(id obj) {
        [hud hide:YES];
        self.communityDict  =[NSMutableDictionary dictionaryWithDictionary:obj];
    } failure:^(id obj) {
        [hud hide:YES];
        self.errorDict = obj;
    }];
}
/*
-(void)loadMoreData
{
    
    _pageCount++;
    
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    
    NSDictionary * dict=@{@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
    [CommunityTool getCommunityMoreDate:@"/post/index" params:dict success:^(id obj) {
        [hud hide:YES];
        NSMutableArray * communityArr =[self.communityDict objectForKey:@"promote_posts"];
        [communityArr addObjectsFromArray:[obj objectForKey:@"promote_posts"]];
        
        [self.communityDict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
        [self.communityDict setObject:communityArr forKey:@"promote_posts"];
        
        HUDSHOW(@"刷新失败");
        
    } failure:^(id obj) {
        [hud hide:YES];
        HUDSHOW(@"刷新失败");
    }];
    
    [_communityList.mj_footer endRefreshing];
}
 */
#pragma mark - private methods
- (void)updateLoginTyepChange
{
    [self getCommunityViewData];
}
-(void)reloadData
{
    [self getCommunityViewData];
}
-(void)presentToActivityView:(NSString*)action andParam:(NSString*)param
{
    if ([action isEqualToString:@"url"]) {
        ActivityViewController * activityVC  =[[ActivityViewController alloc] init];
        activityVC.url = param;
        [self.lcNavigationController pushViewController:activityVC];
    }
    if ([action isEqualToString:@"goods_detail"]) {
        MaskDetailViewController * activityVC  =[[MaskDetailViewController alloc] init];
        
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
#pragma mark - UITableView delegate and dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
    return array.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellStr = @"CommunityTableViewCell";
    
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if(cell == nil){
        
        cell = [[CommunityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.tag = indexPath.section;
    NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
    cell.communityModel=  array[indexPath.section];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
    CommunityModel * model = array[indexPath.section];
    CommeunityDetailViewController * commeunituDetailVC  =[[CommeunityDetailViewController alloc] init];
    commeunituDetailVC.post_id = model.id;
    [self.lcNavigationController pushViewController:commeunituDetailVC];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array =[self.communityDict objectForKey:@"promote_posts"];
    CGFloat  height= [_communityList  cellHeightForIndexPath:indexPath model:array[indexPath.section] keyPath:@"communityModel" cellClass:[CommunityTableViewCell class] contentViewWidth:kScreenWidth];
    
    return height;
}
#pragma mark - setter and getter
- (void)setCommunityDict:(NSMutableDictionary *)communityDict
{
    _communityDict = communityDict;
    
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(!_communityList)
    {
        [self.view addSubview:self.communityList];
    }
    else
    {
        [self.communityList.mj_footer endRefreshing];
        [self.communityList.mj_header endRefreshing];
        [self.communityList reloadData];
    }
    
}
- (void)setErrorDict:(id)errorDict
{
    _errorDict = errorDict;
    if (_communityList) {
        [_communityList  removeFromSuperview];
        _communityList = nil;
    }
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView shareInstance] init];
        _noreachView.error = errorDict;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getCommunityViewData];
        };
        [self.view addSubview:_noreachView];
    }
}
-(UITableView *)communityList
{
    if(!_communityList)
    {
    
        _communityList =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
        _communityList.delegate=self;
        _communityList.tableHeaderView = self.CommunityTopView;
      
        _communityList.dataSource=self;
        _communityList.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
        // 设置footer
//
//        _communityList.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//            [weakSelf loadMoreData];
//        }];
        _communityList.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return _communityList;
}


-(CommunityTopView *)CommunityTopView
{
    if(!_CommunityTopView)
    {
        _CommunityTopView =[[CommunityTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2 + kScreenWidth*0.25 +40)];
        _CommunityTopView.sliderArray =[self.communityDict objectForKey:@"slider"];
        _CommunityTopView.funcationArray =[self.communityDict objectForKey:@"nav"];
         __WEAK_SELF_YLSLIDE
        _CommunityTopView.communtityTopBlock=^(NSString *action, NSString *param) {
            [weakSelf presentToActivityView:action andParam:param];
        };
        
    }
    return _CommunityTopView;
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

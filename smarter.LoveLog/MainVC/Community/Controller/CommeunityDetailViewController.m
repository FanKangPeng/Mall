//
//  CommeunityDetailViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommeunityDetailViewController.h"
#import "ShareManager.h"
#import "Award.h"
#import "CommunityCell.h"
#import "CommunityTool.h"
#import "Curves.h"
#import "NoDataView.h"
#import "CommentListViewController.h"
#import "ActivityViewController.h"
#define imageHeight 100
@interface CommeunityDetailViewController ()
@property(nonatomic,strong)CustomNavigationView *CommunityNavigationView;
@property(nonatomic,strong)NotReachView * noreachView;
@property (nonatomic ,assign)BOOL webViewLoadFail;
@end

@implementation CommeunityDetailViewController

#pragma mark - life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCommunityDeatilData];
}
-(void)initNavigation
{
    //添加导航view
    _CommunityNavigationView =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    
    if(self.communityDeatilModel && !_webViewLoadFail)
    {
        _CommunityNavigationView.shareDict=self.communityDeatilModel.share;
        [self.CommunityNavigationView initViewWithTitle:@"" Back:@"community_delatil_lucency_back.png" andRightName:@"community_delatil_lucency_share.png" andAlpha:0];
    }
    else
        [self.CommunityNavigationView initViewWithTitle:@"帖子详情" Back:@"icon_back.png" andRightName:@"icon_right_share.png" andAlpha:1];
    
    __WEAK_SELF_YLSLIDE
    __STRONG_SELF_YLSLIDE
    _CommunityNavigationView.CustomNavigationLeftImageBlock = ^{
        
        [strongSelf backBtnClick];
    };
    [self.view addSubview:_CommunityNavigationView];
   
}
-(void)backBtnClick
{
    
    if (_communityWebView.canGoBack) {
        [_communityWebView goBack];
    }
    else
    {
        [self.lcNavigationController popViewController];
    }
}

#pragma mark - UIGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}
#pragma mark - UIGestureRecognizer method
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    [self pushToAllComment];
}
#pragma mark - UIWebView KVO method
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.communityWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
   
    if(self.listView.top >=self.communityWebView.scrollView.contentOffset.y-kScreenHeight)
    {
        [self.listView setHidden:NO];
    }
    self.listView.top =self.communityWebView.scrollView.contentSize.height;
    self.communityWebView.scrollView.contentSize  = CGSizeMake(kScreenWidth,self.communityWebView.scrollView.contentSize.height+self.listView.contentSize.height);
    
    [self.communityWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark - UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==100) {
        if (scrollView.contentOffset.y>=self.listView.top-kNavigationHeight) {
            [self.CommunityNavigationView initViewWithTitle:@"热门评论" Back:@"icon_back.png" andRightName:@"icon_right_share.png" andAlpha:1];
        }
        else
        {
            [self.CommunityNavigationView initViewWithTitle:@"" Back:@"community_delatil_lucency_back.png" andRightName:@"community_delatil_lucency_share.png" andAlpha:0];
        }
    }
}

#pragma mark - server methods
//获取详情也数据
-(void)getCommunityDeatilData
{
    
    
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView =[[LoadGIF_M alloc] init];
    [hud show:YES];
    //获取帖子内容数据
    [CommunityTool getCommunityDate:@"/post/detail" params:@{@"id":self.post_id} success:^(id obj) {
        [hud hide:YES];
        self.communityDeatilModel = obj;
        
    } failure:^(id obj) {
        [hud hide:YES];
        self.error = obj;
        
    }];
    
}
//打赏
-(void)rewardCommunity:(NSString*)rewardCount
{
    NSDictionary * dict =@{@"reward":rewardCount,@"post_id":self.communityDeatilModel.id};
    
    [CommunityTool rewardCommunity:@"/post/reward" params:dict success:^(id obj) {
        HUDSHOW(@"打赏成功");
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[Award sharedInstance] awardSuccess];
        });
    } failure:^(id obj) {
        
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               [[Award sharedInstance] awardFailer];
            });
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]){
                 [[Award sharedInstance] awardFailer];
                 [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [[Award sharedInstance] awardFailer];
                });
            }
        }
    }];
}
//点赞
-(void)dianzan
{
    [CommunityTool likeCommunity:@"/digg" params:@{@"id":self.post_id,@"type":@"2"} success:^(id obj) {
        HUDSHOW(@"感谢点赞");
        [self changeButtonStatus];
    } failure:^(id obj) {
        
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
//收藏
-(void)shoucang
{
    [CommunityTool likeCommunity:@"/collect" params:@{@"id":self.post_id,@"type":@"2"} success:^(id obj) {
        [self changeCollectButton:obj];
    } failure:^(id obj) {
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            
            
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
              [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
        }
        
        
    }];
    
}
#pragma mark - private methods
//分享
-(void)shareButtonClick
{
    [[ShareManager sharedInstance] createShareContentWithShareDict:self.communityDeatilModel.share andShareView:self.view];
}
//改变收藏按钮状态
-(void)changeCollectButton:(id)obj
{
    _collectButton.selected=    [[obj objectForKey:@"is_collect"] isEqualToNumber:[NSNumber numberWithLong:0]]  ? NO: YES;
    
    HUDSHOW([obj objectForKey:@"message"]);
    
    [_collectButton setTitle:[NSString stringWithFormat:@"%@",[obj objectForKey:@"collect_count"]] forState:UIControlStateNormal];
}
//改变点赞按钮状态
-(void)changeButtonStatus
{
    if(!_likeButton.selected)
    {
        int  count = [_likeButton.titleLabel.text intValue];
        count ++ ;
        [_likeButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        _likeButton.selected =YES;
    }
}
//跳转到所有评论
-(void)pushToAllComment
{
    CommentListViewController * vc =[[CommentListViewController alloc] init];
    vc.post_id = self.post_id;
    [self.lcNavigationController pushViewController:vc];
}
//打赏
-(void)awardViewTapClick:(UIButton*)tap witheven:(UIEvent*)even
{
    [[Award sharedInstance] awardViewTapClick:tap witheven:even];
    __WEAK_SELF_YLSLIDE
    [Award sharedInstance].AwardBlock=^(NSString *rewardCount) {
        weakSelf.rewardCount =rewardCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        
    };
    
}

-(void)cancelButtonClick
{
    [self.lcNavigationController popViewController];
}
#pragma mark - CustomAlertView delegate
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
        if(buttonIndex ==0)
        {
            [customAlertView hide];
        }
        else
        {
            [self rewardCommunity:self.rewardCount];
        }
}

#pragma mark - UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    NSArray * array  =self.communityDeatilModel.cmt;
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSArray * array  =self.communityDeatilModel.cmt;
    Community_CommentModel * model = [Community_CommentModel mj_objectWithKeyValues:array[indexPath.row]];
    cell.commentModel = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array  =self.communityDeatilModel.cmt;
    CGFloat height =[self.listView cellHeightForIndexPath:indexPath model:[Community_CommentModel mj_objectWithKeyValues:array[indexPath.row]] keyPath:@"commentModel" cellClass:[CommunityCell class] contentViewWidth:kScreenWidth];
 
    return height;
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

#pragma mark  --UIWebView  delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView * view =  self.communityWebView.scrollView.subviews[0];
    view.frame = CGRectMake(0, self.communityDeatilTopView.height, view.width, view.height);
    [self.communityWebView.scrollView addSubview:self.communityDeatilTopView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webViewLoadFail = false;
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回所有图片 以及图片所在的位置
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var srcs = [];\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    srcs[i] = objs[i].src;\
    };\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
    };\
    };\
    return objs.length;\
    };";

    
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        NSArray * imageUrlArr = [str  componentsSeparatedByString:@","];
        [WebImgScrollView showImageWithImageArr:imageUrlArr];
        
    }
    else if ([str isEqualToString:@"about:blank"]){
        
    } else{
        
        if (![str isEqualToString:self.communityDeatilModel.content]) {
            ActivityViewController *webVC = [[ActivityViewController alloc] init];
            webVC.url = str;
            webVC.isSizeTofite = YES;
            [self.lcNavigationController pushViewController:webVC];
            return NO;
        }
    }
    
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //1:移除KVO
    [self.communityWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    //2：导航
    _webViewLoadFail = YES;
    //3:error页面
    self.error = error;
    
    
}
#pragma mark  settet  and getter
- (void)setCommunityDeatilModel:(CommunityDetailModel *)communityDeatilModel
{
    _communityDeatilModel = communityDeatilModel;
    [self.view addSubview:self.tabView];
    if(_noreachView)
    {
        
        [self.CommunityNavigationView initViewWithTitle:@"" Back:@"community_delatil_lucency_back.png" andRightName:@"community_delatil_lucency_share.png" andAlpha:0];
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    if(!_communityWebView)
    {
        [self.view addSubview:self.communityWebView];
        [self initNavigation];
    }
    
    NSArray * cmts = _communityDeatilModel.cmt;
    
    if (cmts.count ==0) {
        [_listView setHidden:YES];
        [_headerView setHidden:YES];
    }
    else
    {
        [_headerView setHidden:NO];
        [_listView setHidden:NO];
    }

    
}
- (void)setError:(id)error
{
    _error = error;
    if (_communityWebView) {
        [_communityWebView removeFromSuperview];
        _communityWebView = nil;
    }
    
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] init];
        _noreachView.error =error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getCommunityDeatilData];
        };
        [self.CommunityNavigationView initViewWithTitle:@"帖子详情" Back:@"icon_back.png" andRightName:@"icon_right_share.png" andAlpha:1];
        [self.view addSubview:_noreachView];
        
        [self initNavigation];
    }
    
}
-(UIView *)headerView
{
    if(!_headerView)
    {
        _headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * pingjia =[[UILabel alloc] initWithFrame:CGRectMake(KLeft, 10, kScreenWidth, 20)];
        pingjia.text=[NSString stringWithFormat:@"热门评论"];
        pingjia.font= DefaultBoldFontSize(16);
        pingjia.textColor=FontColor_black;
        pingjia.textAlignment= NSTextAlignmentLeft;
        [_headerView addSubview:pingjia];
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth-KLeft-95, KLeft, 95, 20);
        [button setTitle:@"查看全部评论" forState:UIControlStateNormal];
        [button setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
        button.titleLabel.font = DefaultFontSize(14);
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(pushToAllComment) forControlEvents:UIControlEventTouchDown];
        [_headerView addSubview:button];
        
        
        Curves*  curves =[[Curves alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 10)];
        [curves setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:curves];
        
        
        
    }
    return _headerView;
}
-(UIWebView *)communityWebView
{
    if(!_communityWebView)
    {
        _communityWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomBarHeight)];
        _communityWebView.delegate=self;
        _communityWebView.scrollView.scrollEnabled = YES;
        _communityWebView.scrollView.tag = 100;
        _communityWebView.scrollView.delegate =self;
        _communityWebView.scalesPageToFit = NO;
        [_communityWebView setBackgroundColor:[UIColor whiteColor]];
        [self.communityWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.communityWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.communityDeatilModel.content]]];
        [self.communityWebView.scrollView addSubview:self.listView];
        [self.listView setHidden:YES];
        // 左滑手势 到全部评论列表
        UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        leftSwipeGestureRecognizer.delegate=self;
        leftSwipeGestureRecognizer.cancelsTouchesInView = NO;
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        
        
        [self.communityWebView addGestureRecognizer:leftSwipeGestureRecognizer];
    }
    return _communityWebView;
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)style:UITableViewStylePlain];
        _listView.delegate=self;
        _listView.dataSource=self;
        _listView.scrollEnabled =NO;
        _listView.tag =200;
        _listView.tableHeaderView = self.headerView;
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        _listView.tableFooterView =view;
        
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _listView;
}
-(UIButton *)collectButton
{
    if(!_collectButton)
    {
        _collectButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setFrame:CGRectMake(0, 0, 52, 20)];
        _collectButton.titleLabel.font = DefaultFontSize(13);
        [_collectButton setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
        //  _collectButton.titleLabel.textAlignment =  NSTextAlignmentLeft;
        _collectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_collectButton setImage:[UIImage imageNamed:@"CollectionNormal"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"CollectionSelected"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchDown];
    }
    return _collectButton;
}
-(UIButton *)commentButton
{
    if(!_commentButton)
    {
        _commentButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setFrame:CGRectMake(0, 0, 52, 20)];
        [_commentButton setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
        _commentButton.titleLabel.font = DefaultFontSize(13);
        //    _commentButton.titleLabel.textAlignment =  NSTextAlignmentLeft;
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_commentButton setImage:[UIImage imageNamed:@"IMG_PostDetail_cmt"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(pushToAllComment) forControlEvents:UIControlEventTouchDown];
    }
    return _commentButton;
}
-(UIButton *)awardButton
{
    if(!_awardButton)
    {
        _awardButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_awardButton setFrame:CGRectMake(0, 0, 52, 20)];
        [_awardButton setImage:[UIImage imageNamed:@"community_award"] forState:UIControlStateNormal];
        [_awardButton addTarget:self action:@selector(awardViewTapClick:witheven:) forControlEvents:UIControlEventTouchDown];
    }
    return _awardButton;
}
-(UIButton *)likeButton
{
    if(!_likeButton)
    {
        _likeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setFrame:CGRectMake(0, 0, 52, 20)];
        //  _likeButton.titleLabel.textAlignment =  NSTextAlignmentLeft;
        _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_likeButton setImage:[UIImage imageNamed:@"IMG_PostDetail_zan"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"IMG_PostDetail_yizanPress"] forState:UIControlStateSelected];
        [_likeButton setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
        _likeButton.titleLabel.font = DefaultFontSize(13);
        [_likeButton addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchDown];
    }
    return _likeButton;
}
-(UIButton *)shareButton
{
    if(!_shareButton)
    {
        _shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"ShareNormal"] forState:UIControlStateNormal];
        
        [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchDown];
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _shareButton.titleLabel.font =DefaultFontSize(11);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:FontColor_gary forState:UIControlStateNormal];
        
        
    }
    return _shareButton;
}
-(CommunityDetailTopView *)communityDeatilTopView
{
    if(!_communityDeatilTopView)
    {
        _communityDeatilTopView  =[[CommunityDetailTopView alloc] initWithFrame:self.view.bounds];
        [_communityDeatilTopView setBackgroundColor:BackgroundColor];
        _communityDeatilTopView.communityDeatilModel =self.communityDeatilModel;
    }
    
    return _communityDeatilTopView;
}
-(UIView *)tabView
{
    if(!_tabView)
    {
        _tabView  =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        [_tabView setBackgroundColor:[UIColor whiteColor]];
        
    }
    else
    {
        [_tabView removeAllSubviews];
    }
    UILabel * line  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SINGLE_LINE_WIDTH)];
    [line setBackgroundColor:ShiXianColor];
    [_tabView addSubview:line];
    
    [_tabView addSubview:self.likeButton];
    _likeButton.sd_layout
    .leftSpaceToView(_tabView,KLeft)
    .topSpaceToView(_tabView,15)
    .heightIs(20)
    .widthIs(52);
        
        [_likeButton setTitle:self.communityDeatilModel.like_count forState:UIControlStateNormal];
        
        if([self.communityDeatilModel.is_like isEqualToString:@"1"])
        {
            _likeButton.selected=YES;
        }else
            _likeButton.selected=NO;
        CGSize strSize = [self.communityDeatilModel.like_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(13)}];
        
        
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _likeButton.width-20)];
        [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(20-strSize.height,4, 0, 0)];
        
        
        [_tabView addSubview:self.collectButton];
        _collectButton.sd_layout
        .leftSpaceToView(_likeButton,0)
        .topEqualToView(_likeButton)
        .heightIs(20)
        .widthIs(52);
        [_collectButton setTitle:self.communityDeatilModel.collect_count forState:UIControlStateNormal];
        
        if([self.communityDeatilModel.is_collect isEqualToString:@"1"])
        {
            _collectButton.selected=YES;
        }
        CGSize strSize1 = [self.communityDeatilModel.like_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(13)}];
        
        
        [_collectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _collectButton.width-20)];
        [_collectButton setTitleEdgeInsets:UIEdgeInsetsMake(20-strSize1.height,4, 0, 0)];
        
        
        [_tabView addSubview:self.shareButton];
        _shareButton.sd_layout
        .leftSpaceToView(_collectButton,0)
        .topEqualToView(_likeButton)
        .heightIs(20)
        .widthIs(52);
        
        CGSize shareButtonSize = [@"分享" sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(13)}];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, _shareButton.width-20)];
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(20-shareButtonSize.height,4, 0, 0)];
        
        [_tabView addSubview:self.commentButton];
        _commentButton.sd_layout
        .leftSpaceToView(_shareButton,0)
        .topEqualToView(_likeButton)
        .heightIs(20)
        .widthIs(52);
        
        [self.commentButton setTitle:self.communityDeatilModel.cmt_count forState:UIControlStateNormal];
        CGSize commentButtonSize = [self.communityDeatilModel.cmt_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(13)}];
        
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, _commentButton.width-20)];
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(20-commentButtonSize.height,4, 0, 0)];
        
        
        [_tabView addSubview:self.awardButton];
        _awardButton.sd_layout
        .rightSpaceToView(_tabView,KLeft)
        .topEqualToView(_likeButton)
        .heightIs(20)
        .widthIs(52);
        
    return _tabView;
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

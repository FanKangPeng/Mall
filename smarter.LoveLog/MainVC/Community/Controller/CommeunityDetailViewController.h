//
//  CommeunityDetailViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

#import "CommunityDetailModel.h"
#import "CommunityDetailTopView.h"

#import "Community_CommentModel.h"
#import "CustomAlertView.h"
#import "WebImgScrollView.h"
@interface CommeunityDetailViewController : SecondBaseViewController<UIScrollViewDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,CustomAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger listHeight;
}
@property (nonatomic, strong) UIWebView *communityWebView;
@property (nonatomic, strong) CommunityDetailTopView *communityDeatilTopView;

@property(nonatomic,strong)CommunityDetailModel * communityDeatilModel;
@property(nonatomic,strong)NSString * post_id;

@property (nonatomic,strong)UIView * tabView;
@property (nonatomic,strong)UIButton * awardButton;
@property (nonatomic,strong)UIButton * collectButton;
@property (nonatomic,strong)UIButton * commentButton;
@property (nonatomic,strong)UIButton * likeButton;
@property (nonatomic,strong)UIButton * shareButton;
@property (nonatomic,strong) NSArray * imageArr;


@property(nonatomic,copy) NSString * rewardCount;
//tableview
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,copy)NSString * capion;
@property(nonatomic,assign)NSUInteger pageCount;
@property (nonatomic ,strong) id  error;

@end

//
//  HelpDeatilViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "HelpDeatilViewController.h"
#import "UserInfoTool.h"
@interface HelpDeatilViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@end

@implementation HelpDeatilViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_noreachView || _webView) {
        [self getData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _setNavigationView =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [_setNavigationView initViewWithTitle:self.title andBack:@"icon_back.png" andRightName:@""];
     __WEAK_SELF_YLSLIDE
    _setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:_setNavigationView];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(!_webView)
    {
        [self.view addSubview:self.webView];
    }
    else
    {
        [self.webView.scrollView.mj_header endRefreshing];
       [_webView loadHTMLString:[self.contentDict objectForKey:@"content"] baseURL:nil];
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
-(void)getData
{
    [UserInfoTool userInfo:@"/help/detail" params:@{@"id":self.post_id} success:^(id obj) {
        [_setNavigationView initViewWithTitle:[obj objectForKey:@"title"] andBack:@"icon_back.png" andRightName:@""];
        self.contentDict = [NSDictionary dictionaryWithDictionary:obj];
        [self initView];
    } failure:^(id obj) {
        [self initFailView:obj];
    }];
}
-(UIWebView *)webView
{
    if (!_webView) {
        _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
        [_webView setBackgroundColor:[UIColor whiteColor]];
        _webView.scrollView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
       // [self loadUrl];
        [_webView loadHTMLString:[self.contentDict objectForKey:@"content"] baseURL:nil];
    }
    return _webView;
}
//-(void)loadUrl
//{
//    NSString * htmlString = [self.contentDict objectForKey:@"content"];
//    if ([htmlString rangeOfString:@"?"].location ==NSNotFound) {
//        htmlString= [htmlString stringByAppendingString:@"?"];
//    }
//    else
//        htmlString= [htmlString stringByAppendingString:@"&"];
//    
//    NSDictionary * sessiondd = [AFNetHttp sharedInstance].sessionDict;
//    
//    if (sessiondd.allKeys.count>0) {
//        NSDate *  senddate=[NSDate date];
//        
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        
//        [dateformatter setDateFormat:@"YYYYMMdd"];
//        
//        NSString *  locationString=[dateformatter stringFromDate:senddate];
//        
//        NSString * params =[NSString stringWithFormat:@"sys=ios&token=%@&time=%@",[NSString stringWithFormat:@"%@_%@",[sessiondd objectForKey:@"sid" ],[sessiondd objectForKey:@"uid"]],locationString];
//        htmlString =  [htmlString stringByAppendingFormat:@"%@",params];
//    }
//    
//    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    
//}
@end

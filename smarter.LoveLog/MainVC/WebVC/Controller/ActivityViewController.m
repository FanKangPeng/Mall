//
//  ActivityViewController.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//


#import "ActivityViewController.h"
#import "ViewController.h"
#import "ShareManager.h"

#import "MyKeyChainHelper.h"

@interface ActivityViewController ()
{
    CustomNavigationView * ActivityNavigationView;
}
@end

@implementation ActivityViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
  
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(30 , 20, 44, 44)];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_web_cancel"] forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchDown];
    }
    
    return _cancelButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    //添加导航view
    ActivityNavigationView =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [ActivityNavigationView initViewWithTitle:@"" andBack:@"icon_back.png" andRightName:@"icon_right_share.png"];
    [self.view addSubview:ActivityNavigationView];
    __WEAK_SELF_YLSLIDE
    ActivityNavigationView.CustomNavigationLeftImageBlock=^{
        //back
        [weakSelf backBtnClick:nil];
    };


    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _activityWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
      [self.view addSubview:_activityWeb];

    _activityWeb.delegate = self;
    _activityWeb.scalesPageToFit = self.isSizeTofite;

  
    _mbProgressHud =[[MBProgressHUD alloc] initWithView:_activityWeb];
      [_activityWeb addSubview:self.mbProgressHud];
    _mbProgressHud.color  =[UIColor clearColor];
    _mbProgressHud.mode= MBProgressHUDModeCustomView;
    _mbProgressHud.customView = [[LoadGIF_M alloc] init];
    
    [self LoadWebView];
}

-(void)back
{
    [self backBtnClick:nil];
}

-(void)LoadWebView
{
    if ([_url rangeOfString:@"?"].location ==NSNotFound) {
        _url= [_url stringByAppendingString:@"?"];
    }
    else
         _url= [_url stringByAppendingString:@"&"];
    
    NSDictionary * sessiondd = [MyKeyChainHelper getSession:KeyChain_SessionKey];
    
    if (sessiondd.allKeys.count>0) {
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYYMMdd"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        NSString * params =[NSString stringWithFormat:@"sys=ios&token=%@&time=%@",[NSString stringWithFormat:@"%@_%@",[sessiondd objectForKey:@"sid" ],[sessiondd objectForKey:@"uid"]],locationString];
        _url =  [_url stringByAppendingFormat:@"%@",params];
    }
    
 
    [_activityWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}
-(void)backBtnClick:(UIButton*)backBtn
{
    if (_activityWeb.canGoBack) {
        [_activityWeb goBack];
    }
    else
    {
        if(_isWebActivity)
            self.ActivityVC(@"BACK");
        [self.lcNavigationController popViewController];
    }
}
-(void)cancelButtonClick
{
    if(_isWebActivity)
        self.ActivityVC(@"BACK");
    [self.lcNavigationController popViewController];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_mbProgressHud show:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_mbProgressHud hide:YES];
    //设置title
    [ActivityNavigationView initViewWithTitle:[_activityWeb stringByEvaluatingJavaScriptFromString:@"document.title"] andBack:@"icon_back.png" andRightName:@"icon_right_share.png"];
    if (![webView.request.URL.absoluteString isEqualToString:self.url]) {
            
        [ActivityNavigationView addSubview:self.cancelButton];
        
        
    }
    
//    NSString *headString = @"document.getElementsByClassName('header')[0].remove();";
//    [webView stringByEvaluatingJavaScriptFromString:headString];
    
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_mbProgressHud hide:YES];
    HUDSHOW(@"加载失败");
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

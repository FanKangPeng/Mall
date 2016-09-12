//
//  SecondView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/3.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondView.h"
#import "CustomRefreshHeader.h"
@implementation SecondView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    [self initMainView];
    return self;
}
-(void)setGoodModel:(GoodModel *)goodModel
{
    _goodModel = goodModel;
    NSURL * url =[NSURL URLWithString:[LoveLog_Host stringByAppendingString:[NSString stringWithFormat:@"/goods/attr&id=%@",self.goodModel.id]]];
    NSURLRequest * request =[NSURLRequest requestWithURL:url];
    [_specificationView loadRequest:request];
    
    
    NSURL * url1 =[NSURL URLWithString:[LoveLog_Host stringByAppendingString:[NSString stringWithFormat:@"/goods/desc&id=%@",self.goodModel.id]]];
    NSURLRequest * request1 =[NSURLRequest requestWithURL:url1];
    [_webView loadRequest:request1];
    
    
}
-(void)initMainView
{
    [self initWebView];
   
    [self initSpecificationView];
    NSArray * titleArr =[NSArray arrayWithObjects:@"图文详情",@"产品规格",@"买家点评", nil];
    titleView   =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    CGFloat btnWidth  = titleView.frame.size.width/titleArr.count;
    [self addSubview:titleView];
    
    UILabel * lowline =[[UILabel alloc] initWithFrame:CGRectMake(0, 44-SINGLE_LINE_WIDTH, kScreenWidth, SINGLE_LINE_WIDTH)];
    [lowline setBackgroundColor:ShiXianColor];
    [titleView addSubview:lowline];
    
    for (int i  =0; i <titleArr.count; i++)
    {
        UIButton * button  =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(btnWidth*i, 1, btnWidth, 43);
        [button setTitleColor:FontColor_gary forState:UIControlStateNormal];
        [button setTitleColor:NavigationBackgroundColor forState:UIControlStateHighlighted];
        [button setTitleColor:NavigationBackgroundColor forState:UIControlStateSelected];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setFont:DefaultBoldFontSize(16)];
        [button setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [titleView addSubview:button];
        
        
        UILabel * shuxian  =[[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width * i -SINGLE_LINE_WIDTH, titleView.frame.size.height/2-10, SINGLE_LINE_WIDTH, 20)];
        [shuxian setBackgroundColor:ShiXianColor];
        [titleView addSubview:shuxian];
        
        if(i==0)
        {
            line =[[UILabel alloc] initWithFrame:CGRectMake(20, 44-SINGLE_LINE_WIDTH, btnWidth-40, SINGLE_LINE_WIDTH)];
            [line setBackgroundColor:NavigationBackgroundColor];
            [titleView addSubview:line];
            [_webView setHidden:NO];
            [_commentsView setHidden:YES];
            [_specificationView setHidden:YES];
            buttonTag = button.tag;
            button.selected =YES;
        }
    }
    
    
}
-(void)buttonClick:(UIButton*)button
{
    if(button.tag !=buttonTag)
    {
        UIButton * lastButton =(UIButton*)[titleView viewWithTag:buttonTag];
        lastButton.selected=NO;
        button.selected=YES;
        
        line.center=CGPointMake(button.center.x, titleView.bounds.size.height-1);
    }
   buttonTag=button.tag;
    
    //button点击事件
    
    
    switch (buttonTag) {
        case 100:
        {
            [_webView setHidden:NO];
            [_specificationView setHidden:YES];
        }
            break;
        case 101:
        {
            [_webView setHidden:YES];
            [_specificationView setHidden:NO];
        }
            break;
        case 102:
        {
            [self.delegate buyerEstimate];
            [_webView setHidden:NO];
            [_specificationView setHidden:YES];
            buttonTag =100;
            UIButton * lastButton =(UIButton*)[titleView viewWithTag:buttonTag];
            lastButton.selected=YES;
            button.selected=NO;
//            
            line.center=CGPointMake(lastButton.center.x, titleView.bounds.size.height-1);
            
        }
            break;
            
        default:
            break;
    }
}
-(void)initSpecificationView
{
    _specificationView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-157)];
    [_specificationView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_specificationView];
    _specificationView.scrollView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

-(void)initWebView
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-157)];
    [_webView setBackgroundColor:[UIColor whiteColor]];
  
    [self addSubview:_webView];
    _webView.scrollView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData
{
    [_webView.scrollView.mj_header endRefreshing];
    [_specificationView.scrollView.mj_header endRefreshing];
    [self.delegate backTop];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  HelpDeatilViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface HelpDeatilViewController : SecondBaseViewController
@property(nonatomic,strong) CustomNavigationView * setNavigationView;

@property(nonatomic,strong)NSString * post_id;
@property(nonatomic,strong)NSDictionary * contentDict;
@property(nonatomic,strong)UIWebView * webView;
@end

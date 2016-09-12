//
//  HelpNextViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface HelpNextViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) CustomNavigationView * setNavigationView;

@property(nonatomic,strong)NSString * post_id;
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSMutableArray * titleArr;
@end

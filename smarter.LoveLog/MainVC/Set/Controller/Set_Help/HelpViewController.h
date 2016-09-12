//
//  HelpViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface HelpViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) CustomNavigationView * setNavigationView;
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSMutableArray * titleArr;

@end

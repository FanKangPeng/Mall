//
//  NotificationViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface NotificationViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSMutableDictionary * messageDict;
@property(nonatomic,assign)NSUInteger pageCount;
@end

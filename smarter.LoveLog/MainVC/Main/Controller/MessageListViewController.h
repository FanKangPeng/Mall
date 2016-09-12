//
//  MessageListViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface MessageListViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *listView;

@end

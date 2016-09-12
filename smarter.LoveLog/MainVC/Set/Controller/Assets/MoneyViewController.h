//
//  MoneyViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "MoneyHeaderView.h"

@interface MoneyViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MoneyHeaderView * headView;
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSDictionary * contentDict;
@end

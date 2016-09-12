//
//  OrderListViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface OrderListViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>
{
    UILabel * redLine ;
    NSUInteger _buttonTag;
    NSMutableArray * _dataArray;
    NSMutableArray *_resultsData;//搜索结果数据
    CustomNavigationView * NavigationView;
    NSString * type;
    CGFloat topHeight;
}
@property (nonatomic,strong)UISearchController *mySearchController;
@property(nonatomic,strong)UITableView * OrderList;
@property(nonatomic,strong)UIView * titleList;
@property (nonatomic,assign) BOOL isShowTitle;
@property (nonatomic,strong)NSString * typeString;
@property(nonatomic,strong)NSMutableDictionary * orderDict;
@property(nonatomic,assign)NSUInteger pageCount;
@end

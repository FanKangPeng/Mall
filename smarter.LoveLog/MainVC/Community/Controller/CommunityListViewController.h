//
//  CommunityListViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"


@interface CommunityListViewController :SecondBaseViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
{
  
    NSMutableArray *_resultsData;//搜索结果数据
    CustomNavigationView * CommunityNavigationView;
    BOOL isActive;
    
}
@property(nonatomic,strong)NSString * post_id;
@property (nonatomic,strong)UITableView * listView;
@property (nonatomic,strong)UISearchController *mySearchController;
@property(nonatomic,strong)NSArray * imageArr;
@property(nonatomic,strong)NSMutableDictionary * communityDict;
@property (nonatomic ,strong) id error;
@property(nonatomic,assign)NSUInteger pageCount;
@end

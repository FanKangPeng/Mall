//
//  CollectViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/23.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface CollectViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>

/**列表*/
@property (nonatomic,strong) UITableView * collectionTableView ;
/**titleView*/
@property (nonatomic,strong) UIView * titleView;
/**titleView的底部标示线*/
@property (nonatomic,strong) UIView * titleLine;
/**titleView记录按钮点击的tag*/
@property (nonatomic,assign) NSUInteger titleTag;
/**数据源*/
@property (nonatomic,strong) NSMutableDictionary * listDataDict;
/**error view*/
@property(nonatomic,strong)NotReachView * noreachView;
/**nodata  view*/
@property(nonatomic,strong)NoDataView * noDataView;

@end



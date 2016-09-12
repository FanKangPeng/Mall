//
//  MyCommentViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface MyCommentViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * redLine ;
    NSUInteger _buttonTag;
    NSMutableArray * _dataArray;
    NSString * type;
}
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)UIView * titleList;
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@property(nonatomic,strong)NSMutableDictionary * myCommentDict;
@property(nonatomic,assign)NSUInteger pageCount;


@end

//
//  RedPacketViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "NoDataView.h"
#import "RedPacketModel.h"

@interface RedPacketViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * redLine ;
    NSUInteger _buttonTag;
    NSMutableArray * _dataArray;
    NSString * type;
    NSInteger usedBonusTag;
}
@property(nonatomic,strong)UITableView * redList;
@property(nonatomic,strong)UIView * titleList;
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@property(nonatomic,strong)NSDictionary * countDict;
@property(nonatomic,strong)NSMutableArray * redPacketList;
@property(nonatomic ,strong) NSString *rightbtnTitle;
@property(nonatomic ,strong) NSArray *bonus;
@property(nonatomic ,strong) NSString *bonus_id;
@property (nonatomic ,copy) void (^usedRedPacketBlokc)(NSDictionary * resultDict);

@end

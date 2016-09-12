//
//  FillInOrderViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "CustomAlertView.h"
#import "FillInOrderTabView.h"
#import "RedPacketofAccountTableViewCell.h"
#import "FillInOrderModel.h"
#import "ExpressageModel.h"
typedef void(^CallBack)(id obj);
@interface FillInOrderViewController : SecondBaseViewController<CustomAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,RedPacketofAccountDelegate>
{
    NSMutableDictionary *defaultDistributionDict;
    NSMutableArray *moneyInfoArr;
    NSString *invoiceStr;
    CGFloat scrollHeight;
    NSDictionary * defaultBonusDict;
    NSString *usedIntegral;
    NSString *postscript;
    NSString *balance;
}
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)FillInOrderTabView* tabView;
@property(nonatomic,strong)NSArray * shoppingArray;

@property (nonatomic ,strong) FillInOrderModel *fillinOrderModel;
@property (nonatomic ,strong) NSError *err;
@property (nonatomic ,strong) NotReachView *faileView;

@property (nonatomic ,strong) NSArray *expressList;
@end

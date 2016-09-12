//
//  ShopCartViewController.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingModel.h"
#import "ShoppingCarCell.h"
#import "NetFaileView.h"

@interface ShopCartViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ShoppingCarCellDelegate>
{
    CGFloat tabHeight;
     CGFloat _totalYOffset;
    BOOL isEdit;
    CustomNavigationView * ShopCartNavigationView;
}
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NetFaileView * netFaileView;
@property(nonatomic,strong)NSMutableDictionary * shoppingCartDict;
@property (nonatomic,assign) BOOL isOtherVCPush;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *editArray;
@property (nonatomic ,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) UIButton *selectAllBtn;//全选按钮

@property (nonatomic,strong) UIButton *jieSuanBtn;//结算按钮
@property (nonatomic,strong) UILabel *totalMoneyLab;//总金额
@property (nonatomic,strong) UIView * sumTabView;
@property (nonatomic ,strong) UIView *editTabView;
@property (nonatomic,strong) UIButton *editSelectAllBtn;//全选按钮
@property (nonatomic ,strong) UIButton *editDeleteBtn;
@property(nonatomic,assign) float allPrice;
@end

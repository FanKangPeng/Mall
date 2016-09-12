//
//  BalanceTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeAndExpenditures.h"
@interface BalanceTableViewCell : UITableViewCell
@property(nonatomic,strong)IncomeAndExpenditures * IncomeAndExpenditures;
@property(nonatomic,strong)UILabel* contentLable;
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* balanceLabel;
@end

//
//  MoneyHeaderView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyHeaderView : UIView
@property(nonatomic,strong)NSDictionary * moneyDict;
@property(nonatomic,strong)UILabel * allMoneyLabel;
@property(nonatomic,strong)UILabel * ableBalanceLabel;
@property(nonatomic,strong)UILabel * withdrawBalanceLabel;

@end

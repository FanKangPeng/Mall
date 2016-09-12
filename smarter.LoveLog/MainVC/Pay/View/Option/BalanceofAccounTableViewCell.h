//
//  BalanceofAccounTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceofAccounTableViewCell : UITableViewCell
@property (nonatomic ,strong) UISwitch *swithBtn;
@property (nonatomic ,copy) NSString *balance;
@property (nonatomic ,copy) void (^UsedBalanceBlock)(NSDictionary * data);
@property (nonatomic ,copy) void (^UnUsedBalanceBlock)();
@end

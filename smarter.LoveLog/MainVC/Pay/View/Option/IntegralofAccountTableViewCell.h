//
//  IntegralofAccountTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralofAccountTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic ,strong) UISwitch *swithBtn;
@property (nonatomic ,strong) NSDictionary *integralDict;
@property (nonatomic ,strong) UILabel *Lb1;
@property (nonatomic ,strong) UILabel *Lb2;
@property (nonatomic ,strong) UILabel *Lb3;
@property (nonatomic ,strong) UITextField *TextField1;
@property (nonatomic ,strong) UIView  *editView;
@property (nonatomic ,copy) void (^IntegralBlock)(NSString *integarl);
@property (nonatomic ,strong)id result;
@property (nonatomic ,copy) void (^UsedIntegralBlock)(NSDictionary * data);
@property (nonatomic ,copy) void (^UnUsedIntegralBlock)();
@end

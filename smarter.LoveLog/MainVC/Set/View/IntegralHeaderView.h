//
//  IntegralHeaderView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralHeaderView : UIView
/**数据源*/
@property(nonatomic,strong)NSDictionary * moneyDict;
/**总积分*/
@property(nonatomic,strong)UILabel * allMoneyLabel;
/**说明文字*/
@property(nonatomic,strong)UILabel * IntroductionsLabel;
/**帮助button*/
@property(nonatomic,strong)UIButton * helpButton;
/**领积分View*/
@property(nonatomic,strong)UIButton * getButton;
/**花View*/
@property(nonatomic,strong)UIButton * flowerButton;
@end

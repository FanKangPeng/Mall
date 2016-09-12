//
//  MoneyHeaderView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MoneyHeaderView.h"

@implementation MoneyHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)setMoneyDict:(NSDictionary *)moneyDict
{
    if (![[moneyDict objectForKey:@"allMoney"] isEqualToString:@""]) {
         _allMoneyLabel.text  =[NSString stringWithFormat:@"%@",[moneyDict objectForKey:@"allMoney"]];
    }
   if (![[moneyDict objectForKey:@"ableBalance"] isEqualToString:@""]) {
        _ableBalanceLabel.text  =[NSString stringWithFormat:@"%@",[moneyDict objectForKey:@"ableBalance"]];
   }
    if (![[moneyDict objectForKey:@"withdrawBalance"] isEqualToString:@""]) {
        _withdrawBalanceLabel.text  =[NSString stringWithFormat:@"%@",[moneyDict objectForKey:@"withdrawBalance"]];

    }
   
    
}
-(void)initView
{
    UILabel * allLabel = [UILabel new];
    allLabel.textAlignment = NSTextAlignmentCenter;
    allLabel.textColor =FontColor_black;
    allLabel.font = DefaultFontSize(15);
    allLabel.text=@"钱包总额";
    [self addSubview:allLabel];
    allLabel.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,25)
    .heightIs(20)
    .widthIs(kScreenWidth/3-SINGLE_LINE_WIDTH);
    
    [self addSubview:self.allMoneyLabel];
    _allMoneyLabel.sd_layout
    .leftEqualToView(allLabel)
    .topSpaceToView(allLabel,0)
    .heightIs(20)
    .widthIs(kScreenWidth/3);
    
    //竖线
    UIView * view =[[UIView alloc] init];
    [view setBackgroundColor:ShiXianColor];
    [self addSubview:view];
    view.sd_layout
    .leftSpaceToView(allLabel,0)
    .topSpaceToView(self,0)
    .heightIs(100)
    .widthIs(SINGLE_LINE_WIDTH);
    
    
    UILabel * userLabel = [UILabel new];
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.textColor =FontColor_black;
    userLabel.font = DefaultFontSize(15);
    userLabel.text=@"可用余额";
    [self addSubview:userLabel];
    userLabel.sd_layout
    .leftSpaceToView(view,KLeft*2)
    .topSpaceToView(self,15)
    .widthIs(kScreenWidth/3)
    .heightIs(20);
    
    [self addSubview:self.ableBalanceLabel];
    _ableBalanceLabel.sd_layout
    .topEqualToView(userLabel)
    .rightSpaceToView(self,KLeft*2)
    .heightIs(20)
    .widthIs(kScreenWidth/3);
    
    //横线
    UIView * view1 =[[UIView alloc] init];
    [view1 setBackgroundColor:ShiXianColor];
    [self addSubview:view1];
    view1.sd_layout
    .leftSpaceToView(view,0)
    .topSpaceToView(self,50)
    .widthIs(kScreenWidth/3*2)
    .heightIs(SINGLE_LINE_WIDTH);
    
    
    UILabel * frozenLabel = [UILabel new];
    frozenLabel.textAlignment = NSTextAlignmentLeft;
    frozenLabel.textColor =FontColor_black;
    frozenLabel.font = DefaultFontSize(15);
    frozenLabel.text=@"提现金额";
    [self addSubview:frozenLabel];
    frozenLabel.sd_layout
    .leftEqualToView(userLabel)
    .topSpaceToView(view1,15)
    .heightIs(20)
    .widthIs(kScreenWidth/3);
    
    [self addSubview:self.withdrawBalanceLabel];
    _withdrawBalanceLabel.sd_layout
    .rightEqualToView(_ableBalanceLabel)
    .topEqualToView(frozenLabel)
    .heightIs(20)
    .widthIs(kScreenWidth/3);
    
    
    

}

-(UILabel *)allMoneyLabel
{
    if (!_allMoneyLabel) {
        _allMoneyLabel =[UILabel new];
        _allMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _allMoneyLabel.font = DefaultFontSize(15);
        _allMoneyLabel.text=@"￥--";
        _allMoneyLabel.textColor = NavigationBackgroundColor;
    }
    return _allMoneyLabel;
}
-(UILabel *)ableBalanceLabel
{
    if (!_ableBalanceLabel) {
        _ableBalanceLabel =[UILabel new];
        _ableBalanceLabel.textAlignment = NSTextAlignmentRight;
        _ableBalanceLabel.font = DefaultFontSize(15);
        _ableBalanceLabel.text=@"￥--";
        _ableBalanceLabel.textColor = NavigationBackgroundColor;
    }
    return _ableBalanceLabel;
}
-(UILabel *)withdrawBalanceLabel
{
    if (!_withdrawBalanceLabel) {
        _withdrawBalanceLabel =[UILabel new];
        _withdrawBalanceLabel.textAlignment = NSTextAlignmentRight;
        _withdrawBalanceLabel.font = DefaultFontSize(15);
        _withdrawBalanceLabel.text=@"￥--";
        _withdrawBalanceLabel.textColor = NavigationBackgroundColor;
    }
    return _withdrawBalanceLabel;
}


@end

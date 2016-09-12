//
//  IntegralHeaderView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "IntegralHeaderView.h"

@implementation IntegralHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:RGBACOLOR(255, 74, 107, 1)];
        [self initView];
    }
    return self;
}
-(void)setMoneyDict:(NSDictionary *)moneyDict
{
    _moneyDict = moneyDict;
    NSString * contentString = [NSString stringWithFormat:@"%@个",[moneyDict objectForKey:@"allMoney"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSRange range = [contentString rangeOfString:@"个"];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(16) range:range];
    _allMoneyLabel.attributedText = str;
}
-(void)initView
{
    [self addSubview:self.allMoneyLabel];
    _allMoneyLabel.sd_layout
    .leftSpaceToView(self,KLeft*3)
    .topSpaceToView(self,KLeft*4)
    .heightIs(50)
    .widthIs(kScreenWidth/2);
    

    
    [self addSubview:self.IntroductionsLabel];
    _IntroductionsLabel.sd_layout
    .topSpaceToView(_allMoneyLabel,KLeft)
    .leftEqualToView(_allMoneyLabel)
    .heightIs(30)
    .widthIs(kScreenWidth-KLeft*4);
    
    [self addSubview:self.helpButton];
    _helpButton.sd_layout
    .topSpaceToView(self,KLeft)
    .rightSpaceToView(self,KLeft)
    .widthIs(80)
    .heightIs(30);
    
    

 
    [self addSubview:self.getButton];
    _getButton.sd_layout
    .leftSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .heightIs(60)
    .widthIs(kScreenWidth/2);
    CGFloat left = 0;
    if (iPhone4 ||iPhone5) {
        left =5;
    }
    else
        left=15;
    _getButton.imageEdgeInsets =  UIEdgeInsetsMake(10, _getButton.width/2-40, 10,_getButton.width/2);
    _getButton.titleEdgeInsets = UIEdgeInsetsMake(15, left, 15,_getButton.width/2-30);
    
    [self addSubview:self.flowerButton];
    _flowerButton.sd_layout
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .heightIs(60)
    .widthIs(kScreenWidth/2);
    _flowerButton.imageEdgeInsets =  UIEdgeInsetsMake(10, _flowerButton.width/2-40, 10,_flowerButton.width/2);
    _flowerButton.titleEdgeInsets = UIEdgeInsetsMake(15,left, 15, _flowerButton.width/2-30);
    //竖线
        UIView * view =[[UIView alloc] init];
        [view setBackgroundColor:RGBACOLOR(255, 119, 144, 1)];
        [self addSubview:view];
        view.sd_layout
        .leftSpaceToView(_getButton,0)
        .bottomSpaceToView(self,0)
        .heightIs(60)
        .widthIs(SINGLE_LINE_WIDTH);
    
    
}
#pragma mark  - setter and getter
-(UILabel *)allMoneyLabel
{
    if (!_allMoneyLabel) {
        _allMoneyLabel =[UILabel new];
        _allMoneyLabel.font = DefaultFontSize(66);
        _allMoneyLabel.text=@"￥--";
        _allMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _allMoneyLabel;
}
-(UILabel *)IntroductionsLabel
{
    if (!_IntroductionsLabel) {
        _IntroductionsLabel =[UILabel new];
        _IntroductionsLabel.textAlignment = NSTextAlignmentLeft;
        _IntroductionsLabel.font = DefaultFontSize(16);
        _IntroductionsLabel.text=@"小积分，有大用，多领一些屯起来！";
        _IntroductionsLabel.textColor = [UIColor whiteColor];
    }
    return _IntroductionsLabel;
}
-(UIButton *)getButton
{
    if (!_getButton) {
        _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getButton setBackgroundColor:RGBACOLOR(241, 62, 95, 1)];
        [_getButton setImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
        [_getButton setTitle:@"领" forState:UIControlStateNormal];
        _getButton.titleLabel.font = DefaultFontSize(19);
        [_getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
        
    }
    return _getButton;
}

-(UIButton *)flowerButton
{
    if (!_flowerButton) {
        _flowerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flowerButton setBackgroundColor:RGBACOLOR(241, 62, 95, 1)];
        [_flowerButton setImage:[UIImage imageNamed:@"cost"] forState:UIControlStateNormal];
        [_flowerButton setTitle:@"花" forState:UIControlStateNormal];
        _flowerButton.titleLabel.font = DefaultFontSize(19);
        [_flowerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    return _flowerButton;
}
-(UIButton *)helpButton
{
    if (!_helpButton) {
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setBackgroundColor:[UIColor clearColor]];
        [_helpButton setTitle:@"使用帮助" forState:UIControlStateNormal];
        _helpButton.titleLabel.font = DefaultFontSize(16);
        [_helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _helpButton;
}
@end

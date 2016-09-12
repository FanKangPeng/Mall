//
//  FillInOrderTabView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FillInOrderTabView.h"

@implementation FillInOrderTabView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
      
        [self addSubview:self.fillinOrderButton];
        _fillinOrderButton.sd_layout
        .rightSpaceToView(self,0)
        .topSpaceToView(self,0)
        .bottomSpaceToView(self,0)
        .widthIs(kScreenWidth/3);
        
        [self addSubview:self.sumLabel];
        _sumLabel.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(_fillinOrderButton,0)
        .topSpaceToView(self,0)
        .bottomSpaceToView(self,0);
        
    }
    return self;
}
-(void)setPrice:(CGFloat)price
{

    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    实付款:￥%.2f",price]];
    [str1 addAttribute:NSFontAttributeName value:DefaultFontSize(16) range:NSMakeRange(8,str1.length-8)];
    self.sumLabel.attributedText = str1;

}
-(UILabel *)sumLabel
{
    if(!_sumLabel)
    {
        _sumLabel =[UILabel new];
        [_sumLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [_sumLabel setTextColor:[UIColor whiteColor]];
        _sumLabel.font = DefaultFontSize(13);
    }
    return _sumLabel;
}
-(UIButton *)fillinOrderButton
{
    if(!_fillinOrderButton)
    {
        _fillinOrderButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_fillinOrderButton setBackgroundColor:NavigationBackgroundColor];
        [_fillinOrderButton setTintColor:[UIColor whiteColor]];
        [_fillinOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_fillinOrderButton addTarget:self action:@selector(fillinOrderButtonClick:) forControlEvents:UIControlEventTouchDown];
        _fillinOrderButton.titleLabel.font = DefaultBoldFontSize(16);
        
    }
    return _fillinOrderButton;
}
-(void)fillinOrderButtonClick:(UIButton*)button
{
    _FillInOrderButtonBlovk();
}


@end

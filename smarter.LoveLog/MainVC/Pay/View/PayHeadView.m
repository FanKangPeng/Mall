//
//  PayHeadView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "PayHeadView.h"

@implementation PayHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
   self =  [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.Img];
        [self addSubview:self.Lb1];
        [self addSubview:self.Lb2];
        [self addSubview:self.Lb3];
        [self addSubview:self.Lb4];
        [self addSubview:self.orderNumberLb];
        [self addSubview:self.orderMoneyLb];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(KLeft, 80, kScreenWidth-20, SINGLE_LINE_WIDTH)];
        [line setBackgroundColor:ShiXianColor];
        [self addSubview:line];
        
       _orderNumberLb.sd_layout
        .leftSpaceToView(_Lb3,0)
        .topEqualToView(_Lb3)
        .widthIs(100)
        .heightIs(20);
        
        _orderMoneyLb.sd_layout
        .rightSpaceToView(self,KLeft)
        .topEqualToView(_Lb4)
        .widthIs(100)
        .heightIs(20);
        
        
        CGSize size = [_Lb4 sizeThatFits:CGSizeMake(kScreenWidth, 20)];
        _Lb4.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_Lb3,10)
        .widthIs(size.width)
        .heightIs(20);
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 20)];
        [view setBackgroundColor:ShiXianColor];
        [self addSubview:view];
        
        
    }
    return self;
}


#pragma mark -- setter getter
- (void)setData:(NSDictionary *)data
{
    _data = data;
    NSString * orderNum  = [data objectForKey:@"orderNum"];
    _orderNumberLb.text = orderNum;
    CGSize size1 = [_orderNumberLb sizeThatFits:CGSizeMake(kScreenWidth, 20)];
    _orderNumberLb.sd_layout
    .rightSpaceToView(self,10)
    .topEqualToView(_Lb3)
    .widthIs(size1.width)
    .heightIs(20);
    
    NSString *money = [data objectForKey:@"orderMoney"];
    _orderMoneyLb .text = money;
    CGSize size2 = [_orderMoneyLb sizeThatFits:CGSizeMake(kScreenWidth, 20)];
    _orderMoneyLb.sd_layout
    .rightSpaceToView(self,KLeft)
    .topEqualToView(_Lb4)
    .widthIs(size2.width)
    .heightIs(20);
    NSNumber * valid_time = [data objectForKey:@"valid_time"];
    _Lb2.text = [NSString stringWithFormat:@"(请在%@分钟内完成支付)",valid_time];
}
- (UIImageView *)Img
{
    if (!_Img) {
        _Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_choice_selected"]];
        _Img.frame = CGRectMake(kScreenWidth/2-55, 20, 20, 20);
    }
    return _Img;
}
- (UILabel *)Lb1
{
    if (!_Lb1) {
        _Lb1 = [UILabel new];
        _Lb1.font = DefaultFontSize(14);
        _Lb1.text = @"订单已提交";
        _Lb1.frame = CGRectMake(kScreenWidth/2 - 30, 20, 150, 20);
    }
    return _Lb1;
}

- (UILabel *)Lb2
{
    if (!_Lb2) {
        _Lb2 = [UILabel new];
        _Lb2.font = DefaultFontSize(14);
        _Lb2.text = @"(请在15分钟内完成支付)";
        _Lb2.frame = CGRectMake(10, 50, kScreenWidth -20, 20);
        _Lb2.textAlignment = NSTextAlignmentCenter;
    }
    return _Lb2;
}
- (UILabel *)Lb3
{
    if (!_Lb3) {
        _Lb3 = [UILabel new];
        _Lb3.font = DefaultFontSize(14);
        _Lb3.text = @"订单编号:";
        CGSize size = [_Lb3 sizeThatFits:CGSizeMake(kScreenWidth, 20)];
        _Lb3.frame = CGRectMake(KLeft, 90, size.width, 20);
    }
    return _Lb3;
}
- (UILabel *)Lb4
{
    if (!_Lb4) {
        _Lb4 = [UILabel new];
        _Lb4.font = DefaultFontSize(14);
        _Lb4.text = @"支付金额:";
        _Lb4.textAlignment = NSTextAlignmentLeft;
    }
    return _Lb4;
}
- (UILabel *)orderMoneyLb
{
    if (!_orderMoneyLb) {
        _orderMoneyLb = [UILabel new];
        [_orderMoneyLb setTextColor:NavigationBackgroundColor];
        _orderMoneyLb.font = DefaultFontSize(15);
        _orderMoneyLb.textAlignment = NSTextAlignmentRight;
        
    }
    return _orderMoneyLb;
}
- (UILabel *)orderNumberLb
{
    if (!_orderNumberLb) {
        _orderNumberLb = [UILabel new];
        [_orderNumberLb setTextColor:NavigationBackgroundColor];
        _orderNumberLb.font = DefaultFontSize(15);
        _orderNumberLb.textAlignment = NSTextAlignmentRight;
    }
    return _orderNumberLb;
}
@end

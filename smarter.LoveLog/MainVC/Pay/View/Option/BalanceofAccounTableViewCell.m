//
//  BalanceofAccounTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "BalanceofAccounTableViewCell.h"

@implementation BalanceofAccounTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = DefaultFontSize(15);
        [self.contentView addSubview:self.swithBtn];
    }
    return self;
}
- (UISwitch *)swithBtn
{
    if (!_swithBtn) {
        _swithBtn = [[UISwitch alloc] init];
        _swithBtn.frame = CGRectMake(kScreenWidth-55, 7, 45, 23);
        [_swithBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _swithBtn;
}
- (void)setBalance:(NSString *)balance
{
    _balance = balance;
    self.textLabel.text = [NSString stringWithFormat:@"账户余额￥%@",balance];
    if ([balance floatValue] > 0) {
        [_swithBtn setOn:YES];
        self.textLabel.textColor = FontColor_black;
        self.userInteractionEnabled = YES;
    }
    else
    {
        self.textLabel.textColor = FontColor_gary;
        self.userInteractionEnabled = NO;
    }
}
- (void)buttonClick:(UISwitch*)sender
{
    if ([sender isOn]) {
        //传递余额金额
        _UsedBalanceBlock(@{@"账户余额":[NSString stringWithFormat:@"-￥%@",_balance]});
    }
    else
         _UnUsedBalanceBlock();
        
}
@end

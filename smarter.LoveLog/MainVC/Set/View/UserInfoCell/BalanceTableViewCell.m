//
//  BalanceTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "BalanceTableViewCell.h"

@implementation BalanceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.balanceLabel];
    }
    return self;
}
-(void)setIncomeAndExpenditures:(IncomeAndExpenditures *)IncomeAndExpenditures
{
    _contentLable.text = IncomeAndExpenditures.change_desc;
    [_contentLable sizeToFit];
    CGSize size  = [_contentLable sizeThatFits:CGSizeMake(kScreenWidth/3*2, MAXFLOAT)];
   
    _contentLable.sd_layout
    .leftSpaceToView(self.contentView,KLeft*1.5)
    .topSpaceToView(self.contentView,KLeft)
    .widthIs(size.width)
    .heightIs(size.height);
    
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",IncomeAndExpenditures.change_time];
    _timeLabel.sd_layout
    .leftEqualToView(_contentLable)
    .topSpaceToView(_contentLable,KLeft)
    .heightIs(20)
    .widthIs(kScreenWidth/3*2);
    
    CGFloat height = 30+ _contentLable.height+_timeLabel.height;
    
    if([IncomeAndExpenditures.prefix isEqualToString:@"-"])
        _balanceLabel.text = [NSString stringWithFormat:@"-%@",IncomeAndExpenditures.value];
    else
        _balanceLabel.text = [NSString stringWithFormat:@"+%@",IncomeAndExpenditures.value];
    [_balanceLabel sizeToFit];
    CGSize size1  = [_balanceLabel sizeThatFits:CGSizeMake(kScreenWidth/3, 40)];
    _balanceLabel.sd_layout
    .rightSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,height/2-20)
    .heightIs(40)
    .widthIs(size1.width);
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:KLeft];
    
}
-(UILabel *)contentLable
{
    if (!_contentLable) {
        _contentLable =[UILabel new];
        _contentLable.textColor = FontColor_black;
        _contentLable.font = DefaultFontSize(15);
        _contentLable.numberOfLines = 0;
        _contentLable.lineBreakMode =  NSLineBreakByCharWrapping;
    }
    return _contentLable;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel =[UILabel new];
        _timeLabel.textColor = FontColor_gary;
        _timeLabel.font = DefaultFontSize(13);
    }
    return _timeLabel;
}
-(UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel =[UILabel new];
        _balanceLabel.textColor = NavigationBackgroundColor;
        _balanceLabel.font = DefaultFontSize(18);
    }
    return _balanceLabel;
}
@end

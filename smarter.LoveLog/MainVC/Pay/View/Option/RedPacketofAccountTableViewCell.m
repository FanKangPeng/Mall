//
//  RedPacketofAccountTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "RedPacketofAccountTableViewCell.h"

@implementation RedPacketofAccountTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.text = @"红包";
        self.textLabel.font = DefaultFontSize(15);
        
        
        
        UIImageView * image =[[UIImageView alloc] init];
        image.image=[UIImage imageNamed:@"icon_right_more.png"];
        [self.contentView addSubview:image];
        image.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,13)
        .heightIs(17)
        .widthIs(10);
        
    }
    return self;
}

- (void)setBonusDict:(NSDictionary *)bonusDict
{
    NSString *bonusStr = [bonusDict objectForKey:@"bonusStr"];
    NSInteger bonus = [[bonusDict objectForKey:@"bonus"] integerValue];
    NSInteger count = [[bonusDict  objectForKey:@"bonusCount"] integerValue];
    if (count <=0 ) {
        if (_distributionLabel) {
            [_distributionLabel removeFromSuperview];
            _distributionLabel =  nil;
        }
        [self.contentView addSubview:self.TypeLabel];
        _TypeLabel.sd_layout
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(self.contentView,13)
        .widthIs(70)
        .heightIs(17);
        _TypeLabel.text = @"无可以红包";
    }else
    {
        if (bonus <= 0) {
            if (_distributionLabel) {
                [_distributionLabel removeFromSuperview];
                _distributionLabel =  nil;
            }
            if (!_TypeLabel) {
                [self.contentView addSubview:self.TypeLabel];
                _TypeLabel.sd_layout
                .rightSpaceToView(self.contentView,25)
                .topSpaceToView(self.contentView,13)
                .widthIs(70)
                .heightIs(17);
               
            }
             _TypeLabel.text = @"未使用红包";
        }
        else
        {
            if (_TypeLabel) {
                [_TypeLabel removeFromSuperview];
                _TypeLabel = nil;
            }
            [self.contentView addSubview:self.distributionLabel];
            _distributionLabel.sd_layout
            .rightSpaceToView(self.contentView,25)
            .topSpaceToView(self.contentView,13)
            .widthIs(100)
            .heightIs(17);
            
            _distributionLabel.text = [NSString stringWithFormat:@"红包减免%@",bonusStr];
            
            [_RedPacketofAccountDelegate usedBonus:@{@"红包抵扣":[NSString stringWithFormat:@"-%@",bonusStr]}];
            //传递红包金额
            
        }

    }
   }

-(UILabel *)distributionLabel
{
    if(!_distributionLabel)
    {
        _distributionLabel =[UILabel new];
        _distributionLabel.font = DefaultFontSize(13);
        _distributionLabel.textColor = [UIColor whiteColor];
        _distributionLabel.textAlignment = NSTextAlignmentCenter;
        
        _distributionLabel.backgroundColor=NavigationBackgroundColor;
        _distributionLabel.layer.cornerRadius=3;
        _distributionLabel.layer.masksToBounds=YES;
        
        
    }
    return _distributionLabel;
}
-(UILabel *)TypeLabel
{
    if(!_TypeLabel)
    {
        _TypeLabel =[UILabel new];
        _TypeLabel.font = DefaultFontSize(11);
        _TypeLabel.textColor = [UIColor whiteColor];
        _TypeLabel.textAlignment = NSTextAlignmentCenter;
        _TypeLabel.text=@"未使用红包";
        _TypeLabel.backgroundColor=NavigationBackgroundColor;
        _TypeLabel.layer.cornerRadius=3;
        _TypeLabel.layer.masksToBounds=YES;
    }
    return _TypeLabel;
}
@end

//
//  DistributionTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "DistributionTableViewCell.h"

@implementation DistributionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initView];
    }
    return self;
}
-(void)initView
{
    [self.contentView addSubview:self.titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,18)
    .widthIs(150)
    .heightIs(24);
    
    UIImageView * image =[[UIImageView alloc] init];
    image.image=[UIImage imageNamed:@"icon_right_more.png"];
    [self.contentView addSubview:image];
    image.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,21)
    .heightIs(17)
    .widthIs(10);
    
    
    [self.contentView addSubview:self.payTypeLb];
    _payTypeLb.sd_layout
    .rightSpaceToView(image,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(150)
    .heightIs(20);
    
    [self.contentView addSubview:self.expressTypeLb];
    _expressTypeLb.sd_layout
    .rightSpaceToView(image,10)
    .topSpaceToView(_payTypeLb,0)
    .widthIs(150)
    .heightIs(20);
    
//    [self.contentView addSubview:self.descriptionLb];
//    _descriptionLb.sd_layout
//    .rightEqualToView(_expressTypeLb)
//    .topSpaceToView(_expressTypeLb,0)
//    .leftSpaceToView(self.contentView,50)
//    .heightIs(20);

}
- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    _payTypeLb .text = [dict objectForKey:@"default_pay_name"];
    _expressTypeLb .text = [dict objectForKey:@"default_shipping_name"];

    
}
- (UILabel *)descriptionLb
{
    if (!_descriptionLb) {
        _descriptionLb = [UILabel new];
        _descriptionLb.font = DefaultFontSize(13);
        _descriptionLb.textColor =  FontColor_black;
        _descriptionLb.textAlignment = NSTextAlignmentRight;
    }
    return _descriptionLb;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel =[UILabel new];
        _titleLabel.font = DefaultFontSize(15);
        _titleLabel.textColor = FontColor_black;
        _titleLabel.text=@"支付配送";
        
    }
    return _titleLabel;
}
-(UILabel *)payTypeLb
{
    if(!_payTypeLb)
    {
        _payTypeLb =[UILabel new];
        _payTypeLb.font = DefaultFontSize(13);
        _payTypeLb.textColor = FontColor_black;
        _payTypeLb.textAlignment = NSTextAlignmentRight;
        
        _payTypeLb.text = @"在线支付";
    }
    return _payTypeLb;
}
-(UILabel *)expressTypeLb
{
    if(!_expressTypeLb)
    {
        _expressTypeLb =[UILabel new];
        _expressTypeLb.font = DefaultFontSize(13);
        _expressTypeLb.textColor = FontColor_black;
        _expressTypeLb.textAlignment = NSTextAlignmentRight;
        
        _expressTypeLb.text = @"平台配送";
    }
    return _expressTypeLb;
}
@end

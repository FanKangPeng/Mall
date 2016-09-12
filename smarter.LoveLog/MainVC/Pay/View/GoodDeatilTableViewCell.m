//
//  GoodDeatilTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "GoodDeatilTableViewCell.h"

@implementation GoodDeatilTableViewCell

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
- (void)setShopModel:(ShoppingModel *)shopModel
{
    _shopModel = shopModel;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.img_thumb] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
    self.titleLabel.text=shopModel.goods_name;
    self.countLabel.text= [NSString stringWithFormat:@"x%@",shopModel.goods_number];
    
    
    
    if (![shopModel.goods_price hasPrefix:@"￥"]) {
        shopModel.goods_price = [NSString stringWithFormat:@"￥%@",shopModel.goods_price];
    }
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",shopModel.goods_price]];
    [str1 addAttribute:NSFontAttributeName value:DefaultFontSize(10) range:NSMakeRange(0,1)];
    self.priceLabel.attributedText = str1;

}

-(void)initView
{
    [self.contentView addSubview:self.goodImageView];
    _goodImageView.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,KLeft)
    .widthIs(kWidth(60))
    .heightIs(kWidth(60));
    
    UIImageView * image =[[UIImageView alloc] init];
    image.image=[UIImage imageNamed:@"icon_right_more.png"];
    [self.contentView addSubview:image];
    image.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,31)
    .heightIs(17)
    .widthIs(10);
    
    
    [self.contentView addSubview:self.titleLabel];
    _titleLabel.sd_layout
    .topEqualToView(_goodImageView)
    .leftSpaceToView(_goodImageView,KLeft)
    .rightSpaceToView(image,10)
    .heightIs(kWidth(20));
    
    [self.contentView addSubview:self.priceLabel];
    _priceLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,0)
    .heightIs(20);
    
    
    [self.contentView addSubview:self.countLabel];
    _countLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_priceLabel,0)
    .heightIs(20);
    
  
    
 
}
-(UIImageView *)goodImageView
{
    if(!_goodImageView)
    {
        _goodImageView =[UIImageView new];
        _goodImageView.layer.cornerRadius=3;
        _goodImageView.layer.masksToBounds=YES;
        _goodImageView.layer.borderWidth=1;
        _goodImageView.layer.borderColor =RGBACOLOR(239, 239, 239, 1).CGColor;
    }
    return _goodImageView;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel =[UILabel new];
        _titleLabel.textColor=FontColor_black;
        _titleLabel.textAlignment= NSTextAlignmentLeft;
        _titleLabel.font = DefaultFontSize(13);
        
    }
    return _titleLabel;
}
-(UILabel *)typeLabel
{
    if(!_typeLabel)
    {
        _typeLabel =[UILabel new];
        _typeLabel.textColor= FontColor_black;
        _typeLabel.font =DefaultFontSize(13);
    }
    return _typeLabel;
}
-(UILabel *)countLabel
{
    if(!_countLabel)
    {
        _countLabel =[UILabel new];
        _countLabel.textColor= FontColor_black;
        _countLabel.font =DefaultFontSize(13);
    }
    return _countLabel;
}
-(UILabel *)priceLabel
{
    if(!_priceLabel)
    {
        _priceLabel =[UILabel new];
        _priceLabel.textColor= NavigationBackgroundColor;
        _priceLabel.font =DefaultFontSize(13);
    }
    return _priceLabel;
}
@end

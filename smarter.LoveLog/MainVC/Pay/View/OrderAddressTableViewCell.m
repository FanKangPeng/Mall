//
//  OrderAddressTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "OrderAddressTableViewCell.h"

@implementation OrderAddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView * backImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        backImage.image =[UIImage imageNamed:@"order_address_background"];
        [self.contentView addSubview:backImage];
        [self initView];
    }
    return self;
}
-(void)setAddressModel:(AddressModel *)addressModel
{
    if(addressModel.consignee)
    {
        [_noAddressLb setHidden:true];
        [_adressView setHidden:false];
        _nameLabel.text=addressModel.consignee;
        CGSize size =  [_nameLabel sizeThatFits:CGSizeMake(300, 30)];
        _nameLabel.sd_layout
        .widthIs(size.width);
        _iphoneLabel.text=addressModel.mobile;
        
        _addressLabel.text = [[[addressModel.province_name stringByAppendingString:[NSString stringWithFormat:@"-%@",addressModel.city_name]] stringByAppendingString:[NSString stringWithFormat:@"-%@",addressModel.district_name]] stringByAppendingString:[NSString stringWithFormat:@"-%@",addressModel.address]];
        if (![addressModel.is_default isEqualToString:@"1"]) {
            [_typeLabel removeFromSuperview];
            _typeLabel = nil;
            _addressLabel.sd_layout
            .leftSpaceToView(self.adressView,KLeft);
        }
        else
        {
            if (!_typeLabel) {
                [self.adressView addSubview:self.typeLabel];
                _typeLabel.sd_layout
                .leftSpaceToView(self.adressView,KLeft)
                .topSpaceToView(_nameLabel,3)
                .heightIs(15)
                .widthIs(40);
                _addressLabel.sd_layout
                .leftSpaceToView(_typeLabel,13)
                .rightSpaceToView(self.adressView,KLeft*2);
            }
        }
    }
    else
    {
        [_adressView setHidden:YES];
        [_noAddressLb setHidden:false];
        _noAddressLb.text=@"请添加收货地址";
    }
}
-(void)initView
{
    [self.contentView addSubview:self.noAddressLb];
    _noAddressLb.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,20)
    .widthIs(kScreenWidth-20)
    .heightIs(40);
    
    [self.contentView addSubview:self.adressView];
    _adressView.sd_layout
    .leftSpaceToView(self.contentView , 0)
    .topSpaceToView(self.contentView ,0)
    .rightSpaceToView(self.contentView ,0)
    .bottomSpaceToView(self.contentView,0);
    
    UIImageView *  nameImage =[UIImageView new];
    nameImage.image =[UIImage imageNamed:@"order_address_name"];
    [self.adressView addSubview:nameImage];
    nameImage.sd_layout
    .leftSpaceToView(self.adressView,KLeft)
    .topSpaceToView(self.adressView,KLeft*2)
    .widthIs(kWidth(15))
    .heightIs(kWidth(15));
    
    [self.adressView addSubview:self.nameLabel];
    CGSize size =[self.nameLabel sizeThatFits:CGSizeMake(kScreenWidth-kWidth(50), 30)];
    _nameLabel.sd_layout
    .leftSpaceToView(nameImage,KLeft/2)
    .topSpaceToView(self.adressView,KLeft*1.3)
    .widthIs(size.width)
    .heightIs(30);
    
    UIImageView  * iphoneImage =[UIImageView new];
    iphoneImage.image =[UIImage imageNamed:@"order_address_phone"];
    [self.adressView addSubview:iphoneImage];
    
    iphoneImage.sd_layout
    .topEqualToView(nameImage)
    .leftSpaceToView(_nameLabel,10)
    .heightIs(kWidth(15))
    .widthIs(kWidth(15));
    
    [self.adressView addSubview:self.iphoneLabel];
    _iphoneLabel.sd_layout
    .topEqualToView(_nameLabel)
    .leftSpaceToView(iphoneImage,KLeft/2)
    .rightSpaceToView(self.adressView,KLeft*2)
    .heightIs(30);
    
    UIImageView * image =[[UIImageView alloc] init];
    image.image=[UIImage imageNamed:@"icon_right_more.png"];
    [self.adressView addSubview:image];
    image.sd_layout
    .rightSpaceToView(self.adressView,10)
    .topSpaceToView(self.adressView,31)
    .heightIs(17)
    .widthIs(10);
    

    [self.adressView addSubview:self.typeLabel];
    _typeLabel.sd_layout
    .leftEqualToView(nameImage)
    .topSpaceToView(_nameLabel,3)
    .heightIs(15)
    .widthIs(40);
    
    [self.adressView addSubview:self.addressLabel];
    _addressLabel.sd_layout
     .leftSpaceToView(_typeLabel,3)
    .topSpaceToView(_nameLabel,3)
    .rightSpaceToView(image,10)
    .heightIs(15);
}
- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.text=@"默认";
        _typeLabel.textColor=[UIColor whiteColor];
        _typeLabel.backgroundColor=NavigationBackgroundColor;
        _typeLabel.font =DefaultFontSize(12);
        _typeLabel.textAlignment=NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius=3;
        _typeLabel.layer.masksToBounds=YES;
    }
    return _typeLabel;
}
- (UIView *)adressView
{
    if (!_adressView) {
        _adressView = [UIView new];
        [_adressView setBackgroundColor:[UIColor clearColor]];
    }
    return _adressView;
}
-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel =[UILabel new];
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.font = DefaultFontSize(16);
        _nameLabel.text=@"樊康鹏";
        
    }
    return _nameLabel;
}
-(UILabel *)iphoneLabel
{
    if(!_iphoneLabel)
    {
        _iphoneLabel =[UILabel new];
        _iphoneLabel.textAlignment=NSTextAlignmentLeft;
        _iphoneLabel.textColor=[UIColor blackColor];
        _iphoneLabel.font = DefaultFontSize(16);
        _iphoneLabel.text=@"15936219505";
       
        
        
    }
    return _iphoneLabel;
}
-(UILabel *)addressLabel
{
    if(!_addressLabel)
    {
        _addressLabel =[UILabel new];
        _addressLabel.textAlignment=NSTextAlignmentLeft;
        _addressLabel.textColor=[UIColor grayColor];
        _addressLabel.font = DefaultFontSize(13);
        _addressLabel.text=@"上海市浦东新区张江镇广兰路1155弄";
        
    }
    return _addressLabel;
}
- (UILabel *)noAddressLb
{
    if (!_noAddressLb) {
        _noAddressLb = [UILabel new];
        _noAddressLb.textAlignment =  NSTextAlignmentCenter;
        _noAddressLb .font = DefaultFontSize(15);
        
    }
    return _noAddressLb;
}

@end

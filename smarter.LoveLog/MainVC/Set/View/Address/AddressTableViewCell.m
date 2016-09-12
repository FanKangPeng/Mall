//
//  AddressTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AddressTableViewCell.h"


@implementation AddressTableViewCell


- (void)setShowSelectImg:(BOOL)showSelectImg
{
    if (showSelectImg) {
        [_selectImg setHidden:NO];
    }
}
-(void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
    _nameLabel.text = addressModel.consignee;
    CGSize size =[_nameLabel sizeThatFits:CGSizeMake(kScreenWidth, 20)];
    _nameLabel.sd_layout
    .widthIs(size.width)
    .heightIs(20);
    _numLabel.text = addressModel.mobile;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",addressModel.province_name,addressModel.city_name,addressModel.district_name,addressModel.address];
    CGSize size2 =[_addressLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*8, MAXFLOAT)];
    [_addressLabel sizeToFit];
    _addressLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,80)
    .topSpaceToView(_nameLabel,KLeft/2)
    .heightIs(size2.height);
    
    if ([addressModel.is_default isEqualToString:@"1"]) {
        _defaultButton.selected = YES;
        _defaultLabel.text=@"默认地址";
        _defaultLabel.textColor = NavigationBackgroundColor;
        _view1.userInteractionEnabled = NO;
    }
    else
    {
        _defaultButton.selected = NO;
        _defaultLabel.text=@"设为默认地址";
        _defaultLabel.textColor = FontColor_lightGary;
         _view1.userInteractionEnabled = YES;
    }
    
    [self setupAutoHeightWithBottomView:self.view1 bottomMargin:10];
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] init];
        _nameLabel.textColor = FontColor_black;
        _nameLabel.font = DefaultFontSize(14);

    }
    return _nameLabel;
}
-(UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel =[[UILabel alloc] init];
        _numLabel.textColor = FontColor_black;
        _numLabel.font = DefaultFontSize(14);
    }
    return _numLabel;
}
-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth-20, 50)];
        _addressLabel.textColor = FontColor_gary;
        _addressLabel.font = DefaultFontSize(13);
        _addressLabel.numberOfLines = 0;
        _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _addressLabel;
}
- (UIImageView *)selectImg
{
    if (!_selectImg) {
        _selectImg = [UIImageView new];
        _selectImg.image = [UIImage imageNamed:@"address_select_icon"];
        [_selectImg setHidden:true];
    }
    return _selectImg;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView * backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        [backView setBackgroundColor:BackgroundColor];
        [self.contentView addSubview:backView];
    
        [self.contentView addSubview:self.nameLabel];
        CGSize size =[_nameLabel sizeThatFits:CGSizeMake(kScreenWidth, 20)];
        _nameLabel.sd_layout
        .leftSpaceToView(self.contentView,KLeft)
        .topSpaceToView(backView,KLeft)
        .widthIs(size.width)
        .heightIs(20);
        
    
        [self.contentView addSubview:self.numLabel];
        _numLabel.sd_layout
        .leftSpaceToView(_nameLabel,KLeft)
        .topEqualToView(_nameLabel)
        .rightSpaceToView(self.contentView,0)
        .heightIs(20);
        
      
        [self.contentView addSubview:self.addressLabel];
        CGSize size2 =[_addressLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*8, MAXFLOAT)];
        [_addressLabel sizeToFit];
        _addressLabel.sd_layout
        .leftEqualToView(_nameLabel)
        .topSpaceToView(_nameLabel,KLeft)
        .rightSpaceToView(self.contentView,KLeft)
        .heightIs(size2.height);
        
        UIImageView * xuxian =[[UIImageView alloc] initWithFrame:CGRectMake(0, 85, kScreenWidth, 1)];
        [xuxian setImage:[UIImage imageNamed:@"address_xuxian.png"]];
        [self.contentView addSubview:xuxian];
        xuxian.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(_addressLabel,KLeft/2)
        .heightIs(1)
        .widthIs(kScreenWidth);
        
        
        _view1 =[[UIView alloc] initWithFrame:CGRectMake(10, 86, 120, 20)];
        UITapGestureRecognizer * tap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Click)];
        [_view1 addGestureRecognizer:tap1];
        _defaultButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _defaultButton.frame = CGRectMake(0, 0, 20, 20);
        [_defaultButton setBackgroundImage:[UIImage imageNamed:@"icon_choice"] forState:UIControlStateNormal];
        [_defaultButton setBackgroundImage:[UIImage imageNamed:@"icon_choice_selected"] forState:UIControlStateSelected];
        [_defaultButton addTarget:self action:@selector(tap1Click) forControlEvents:UIControlEventTouchDown];
        [_view1 addSubview:_defaultButton];
        
        
        _defaultLabel =[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 20)];
        _defaultLabel.text=@"设为默认地址";
        _defaultLabel.textColor = FontColor_lightGary;
        _defaultLabel.font =DefaultFontSize(12);
        [_view1 addSubview:_defaultLabel];
        
        
        
        [self.contentView addSubview:self.view1];
        _view1.sd_layout
        .leftEqualToView(_addressLabel)
        .topSpaceToView(xuxian,KLeft)
        .heightIs(20)
        .widthIs(120);
        
        
        UIView * view3 =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-60, 86, 50, 20)];
        UITapGestureRecognizer * tap3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Click:)];
        [view3 addGestureRecognizer:tap3];
        
        UIImageView * image2 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        image2.image =[UIImage imageNamed:@"icon_address_delete"];
        [view3 addSubview:image2];
        
        UILabel * label2 =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 20)];
        label2.textColor= FontColor_lightGary;
        label2.text=@"删除";
        label2.font = DefaultFontSize(12);
        [view3 addSubview:label2];
        [self.contentView addSubview:view3];
        view3.sd_layout
        .rightSpaceToView(self.contentView,KLeft)
        .topEqualToView(_view1)
        .heightIs(20)
        .widthIs(50);
        
        
        
        UIView * view2 =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-140, 86, 50, 20)];
        UITapGestureRecognizer * tap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Click:)];
        [view2 addGestureRecognizer:tap2];
        UIImageView * image1 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        image1.image =[UIImage imageNamed:@"icon_address_editor"];
        [view2 addSubview:image1];
        
        UILabel * label1 =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 20)];
        label1.textColor= FontColor_lightGary;
        label1.text=@"编辑";
        label1.font = DefaultFontSize(12);
        [view2 addSubview:label1];
        [self.contentView addSubview:view2];
        view2.sd_layout
        .rightSpaceToView(view3,KLeft)
        .topEqualToView(view3)
        .widthIs(50)
        .heightIs(20);
        
        
        
        [self.contentView addSubview:self.selectImg];
        _selectImg.sd_layout
        .rightSpaceToView(self.contentView,25 )
        .topSpaceToView(self.contentView,25)
        .heightIs(kWidth(20))
        .widthIs(kWidth(30));
      
    }
    
    return self;
}
//设为默认
-(void)tap1Click
{
    _addressCellBlockDefault(self.addressModel.id);
}

//编辑
-(void)tap2Click:(UIGestureRecognizer*)tap2
{
    _addressCellBlockEdit([NSString stringWithFormat:@"%ld",(long)self.tag]);
}
//删除
-(void)tap3Click:(UIGestureRecognizer*)tap3
{
    _addressCellBlockDelete(self.addressModel.id);
}



@end

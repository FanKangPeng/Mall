//
//  OrderCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "OrderCell.h"
#import "OrderModel.h"
#import "GoodModel.h"
@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView * headView =[[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, KLeft)];
        [headView setBackgroundColor:BackgroundColor];
        [self.contentView addSubview:headView];
        [self.contentView addSubview:self.IDlabel];
        _IDlabel.sd_layout
        .leftSpaceToView(self.contentView,KLeft)
        .topSpaceToView(self.contentView,KLeft*2)
        .widthIs(kScreenWidth/2)
        .heightIs(20);
        [self.contentView addSubview:self.rightLable];
        _rightLable.sd_layout
        .rightSpaceToView(self.contentView,KLeft)
        .topEqualToView(_IDlabel)
        .heightIs(20)
        .widthIs(kScreenWidth);
        
        [self.contentView addSubview:self.buttonView];
        
      
        
   
//        [self.contentView addSubview:self.button1];
//        [self.contentView addSubview:self.button2];
    }
    return self;
}
-(void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    _IDlabel.text  =orderModel.order_id;

    _rightLable.text =@"";
    
    _priceLabel.text=orderModel.total_fee;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(12) range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(20) range:NSMakeRange(1, _priceLabel.text.length-1)];
    _priceLabel.attributedText = str;
    if (!_orderContentView) {
        
        
        _orderContentView =[[UIView alloc] initWithFrame:CGRectMake(KLeft, 40, kScreenWidth-20, 95)];
        [_orderContentView setBackgroundColor:RGBACOLOR(247, 247, 247, 1)];
        [self.contentView addSubview:_orderContentView];
        _orderContentView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(_IDlabel,KLeft)
        .heightIs(95)
        .rightSpaceToView(self.contentView,0);
        
        
        
        for (int i = 0; i <orderModel.goods_list.count; i++)
        {
            NSDictionary * goodDict =orderModel.goods_list[i];
            UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(KLeft+75*i, _orderContentView.frame.size.height/2-35, 70, 70)];
            NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[goodDict objectForKey:@"img"] objectForKey:@"cover"]]];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
            imageView.layer.cornerRadius=3;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth=1;
            imageView.layer.borderColor =RGBACOLOR(239, 239, 239, 1).CGColor;
            [_orderContentView addSubview:imageView];
        }
        
        if(orderModel.goods_list.count<=1)
        {
            UILabel * contentLabel =[[UILabel alloc] initWithFrame:CGRectMake(10+80*orderModel.goods_list.count , _orderContentView.frame.size.height/2-35, _orderContentView.frame.size.width-80*orderModel.goods_list.count, 70)];
            
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.font = DefaultFontSize(13);
            contentLabel.textColor =FontColor_gary;
            contentLabel.numberOfLines =0;
            contentLabel.lineBreakMode =NSLineBreakByWordWrapping;
            NSDictionary * goodDict =[orderModel.goods_list firstObject];
            
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[goodDict objectForKey:@"name"]];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:7];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [[goodDict objectForKey:@"name"] length])];
            [contentLabel setAttributedText:attributedString1];
            [contentLabel sizeToFit];
            [_orderContentView addSubview:contentLabel];
        }
        
    }
    
    
 
    
//    
//    NSString  * button1Text =@"";
//    NSString * button2text =@"";
//    UIColor * button1Color = nil;
//    UIColor * button2Color = nil;
//    
//    
//    if([_type isEqualToString:@"2"])
//    {
//        button1Text =@"去付款";
//        button2text =@"取消订单";
//        button1Color = NavigationBackgroundColor;
//        button2Color = FontColor_lightGary;
//    }
//    
//    if([_type isEqualToString:@"3"])
//    {
//        button1Text =@"确认收货";
//        button2text =@"查看物流";
//        button1Color = NavigationBackgroundColor;
//        button2Color = FontColor_lightGary;
//    }
//    if([_type isEqualToString:@"4"])
//    {
//        button1Text =@"删除订单";
//        button2text =@"追加评价";
//        button1Color = FontColor_lightGary;
//        button2Color = FontColor_lightGary;
//    }
//    if([_type isEqualToString:@"5"])
//    {
//        button1Text =@"提醒发货";
//        button2text =@"取消订单";
//        button1Color = NavigationBackgroundColor;
//        button2Color = FontColor_lightGary;
//    }
//    
//
//  
//    
//    _button2.layer.borderColor =button2Color.CGColor;
//    [_button2 setTitleColor:button2Color forState:UIControlStateNormal];
//    [_button2 setTitle:button2text forState:UIControlStateNormal];
//    _button2.sd_layout
//    .rightSpaceToView(self.contentView,KLeft)
//    .heightIs(20)
//    .topEqualToView(_priceLabel)
//    .widthIs(55);
//    
//    _button1.layer.borderColor =button1Color.CGColor;
//    [_button1 setTitleColor:button1Color forState:UIControlStateNormal];
//    [_button1 setTitle:button1Text forState:UIControlStateNormal];
//    _button1.sd_layout
//    .rightSpaceToView(_button2,KLeft)
//    .topEqualToView(_button2)
//    .heightIs(20)
//    .widthIs(55);

    
}


-(UILabel *)IDlabel
{
    if (!_IDlabel) {
       _IDlabel=[[UILabel alloc] init];
        _IDlabel.font = DefaultFontSize(13);
        _IDlabel.textAlignment= NSTextAlignmentLeft;
        _IDlabel.textColor =FontColor_black;
    }
    return _IDlabel;
}
-(UILabel *)rightLable
{
    if (!_rightLable) {
        _rightLable =[[UILabel alloc] init];
        _rightLable.textAlignment = NSTextAlignmentRight;
        _rightLable.font = DefaultFontSize(13);
        _rightLable.textColor = NavigationBackgroundColor;
    }
    return _rightLable;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
       _contentLabel =[[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = DefaultFontSize(13);
        _contentLabel.textColor =FontColor_gary;
        _contentLabel.numberOfLines =3;
        _contentLabel.lineBreakMode =NSLineBreakByWordWrapping;

    }
    return _contentLabel;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] init];
        _priceLabel.textColor = FontColor_black;
        _priceLabel.textAlignment= NSTextAlignmentLeft;
    }
    return _priceLabel;
}
-(UIButton *)button1
{
    if (!_button1) {
       _button1 =[UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(0, 0, 70, 30);
        _button1.layer.cornerRadius =3;
        _button1.layer.masksToBounds=YES;
        _button1.layer.borderWidth=1;
        _button1.titleLabel.font =DefaultFontSize(11);
        [_button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchDown];

    }
    return _button1;
}
-(UIButton *)button2
{
    if (!_button2) {
        _button2 =[UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(0,0, 70, 30);
        _button2.layer.cornerRadius =3;
        _button2.layer.masksToBounds=YES;
        _button2.layer.borderWidth=1;
        _button2.titleLabel.font =DefaultFontSize(11);
        [_button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchDown];
    }
    return _button2;
}
-(UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, kScreenWidth, 40)];
        [_buttonView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * textLable =[[UILabel alloc] init];
        textLable.text=@"实付款:";
        textLable.font = DefaultFontSize(13);
        CGSize size =[textLable sizeThatFits:CGSizeMake(textLable.frame.size.width, MAXFLOAT)];
        textLable.textColor =FontColor_gary;
        [_buttonView addSubview:textLable];
        textLable.sd_layout
        .leftEqualToView(_IDlabel)
        .topSpaceToView(_buttonView,_buttonView.height/2)
        .heightIs(20)
        .widthIs(size.width);
        
        
        [_buttonView addSubview:self.priceLabel];
        _priceLabel.sd_layout
        .leftSpaceToView(textLable,KLeft)
        .topEqualToView(textLable)
        .heightIs(20)
        .widthIs(100);
        
    }
    return _buttonView;
}
-(void)button1Click:(UIButton*)button
{
    if([button.titleLabel.text isEqualToString:@"去付款"])
    {
        self.OrderCellBlock(1,_orderModel.order_id);
       // _orderCellBlock(1,_orderModel.order_id);
    }
    if([button.titleLabel.text isEqualToString:@"提醒发货"])
    {
        
    }
    if([button.titleLabel.text isEqualToString:@"确认收货"])
    {
         self.OrderCellBlock(2,_orderModel.order_id);
    }
    if([button.titleLabel.text isEqualToString:@"删除订单"])
    {
        
    }
}
-(void)button2Click:(UIButton*)button
{
    if([button.titleLabel.text isEqualToString:@"取消订单"])
    {
         self.OrderCellBlock(0,_orderModel.order_id);
    }
    if([button.titleLabel.text isEqualToString:@"查看物流"])
    {
        
    }
    if([button.titleLabel.text isEqualToString:@"追加评价"])
    {
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

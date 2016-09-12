//
//  ShoppingCarCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initView];
        
    }
    return self;
}

-(void)initView{
    //内容
    [self.contentView addSubview:self.contentV];
    _contentV.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .heightIs(100);
   
    [_contentV addSubview:self.checkBtn];
    _checkBtn.sd_layout
    .leftSpaceToView(_contentV,0)
    .topSpaceToView(_contentV,_contentV.height/2- kWidth(25))
    .widthIs(kWidth(50))
    .heightIs(kWidth(50));
    
    
    [_contentV addSubview:self.shopImageV];
    
    _shopImageV.sd_layout
    .leftSpaceToView(_checkBtn,0)
    .topSpaceToView(_contentV,kWidth(10))
    .widthIs(80)
    .heightIs(80);
    
    
    [_contentV addSubview:self.detailsV];
    _detailsV.sd_layout
    .leftSpaceToView(_shopImageV,0)
    .topSpaceToView(_contentV,kWidth(10))
    .bottomSpaceToView(_contentV,kWidth(10))
    .rightSpaceToView(_contentV,0);
    
    [_detailsV addSubview:self.shopNameLb];
    
    _shopNameLb.sd_layout
    .leftSpaceToView(_detailsV,KLeft)
    .topSpaceToView(_detailsV,3)
    .rightSpaceToView(_detailsV,KLeft)
    .heightIs(20);
    
    
    
    [_detailsV addSubview:self.priceLb];
    _priceLb.sd_layout
    .leftSpaceToView(_detailsV,KLeft)
    .topSpaceToView(_shopNameLb,5)
    .heightIs(20)
    .widthIs(50);
    
    
    [_detailsV addSubview: self.numberTitleLb];
    
    _numberTitleLb.sd_layout
    .leftSpaceToView(_detailsV,KLeft)
    .topSpaceToView(_priceLb,5)
    .heightIs(15)
    .widthIs(100);
    
    
//    [_detailsV addSubview:self.shopTypeLb];
//    
//    _shopTypeLb.sd_layout
//    .leftSpaceToView(_detailsV,KLeft)
//    .bottomSpaceToView(_detailsV,20)
//    .rightSpaceToView(_numberTitleLb,KLeft)
//    .heightIs(20);
  

    [_contentV addSubview:self.editV];
    [_editV setHidden:YES];
    _editV.sd_layout
    .leftSpaceToView(_shopImageV,0)
    .topSpaceToView(_contentV,kWidth(10))
    .bottomSpaceToView(_contentV,kWidth(10))
    .rightSpaceToView(_contentV,0);
    
    
//    [_editV addSubview:self.deleteBtn];
//    _deleteBtn.sd_layout
//    .rightSpaceToView(_editV,0)
//    .topSpaceToView(_editV,0)
//    .bottomSpaceToView(_editV,0)
//    .widthIs(55);
    [_editV addSubview:self.shopNameLb2];
    _shopNameLb2.sd_layout
    .leftSpaceToView(_editV,KLeft)
    .topSpaceToView(_editV,3)
    .rightSpaceToView(_editV,KLeft)
    .heightIs(20);
    
    
    
    [_editV addSubview:self.addNumberView];
    _addNumberView.sd_layout
    .leftSpaceToView(_editV,KLeft)
    .topSpaceToView(_shopNameLb2,5)
    .rightSpaceToView(_editV,KLeft)
    .heightIs(44);
    
 
    [self setupAutoHeightWithBottomView:_contentV bottomMargin:0];
    
}
#pragma mark -- AddNumberView delegate

-(void)textFileBeginEditDelegate:(UITextField *)textField
{
    [self.delegate textFileBeginEditDelegate:textField andCell:self];
}
-(void)textFileEndEditDelegate:(UITextField *)textField
{
    [self.delegate textFileEndEditDelegate:textField andCell:self];
}

/**
 * 点击减按钮数量的减少
 *
 * @param sender 减按钮
 */
- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
    NSLog(@"减按钮");
    
    [self.delegate btnClick:self andFlag:(int)sender.tag];

    
}
/**
 * 点击加按钮数量的增加
 *
 * @param sender 加按钮
 */
- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
    NSLog(@"加按钮");
    [self.delegate btnClick:self andFlag:(int)sender.tag];


}
#pragma mark -- privates masters

-(void)checkButtonClick:(UIButton*)button
{
    if(button.selected)
    {
        button.selected = NO;
    }
    else
        button.selected = YES;
    
  
    [self.delegate  checkButtonClick:self andState:button.selected];
    
}
//未用到
- (void)editBtnClick:(UIButton*)button
{
    _editV.hidden = button.selected;
    button.selected =!button.selected;
    _detailsV.hidden = button.selected;
    
    if (!button.selected) {
        _updataBlock(self.shoppingModel);
    }
}

- (void)deleteBtnClick:(UIButton*)button
{
    _deleteBlock(self.shoppingModel);
  
    FLog(@"删除");
}
#pragma setter and getter
-(void)setShoppingModel:(ShoppingModel *)shoppingModel{
    
    _shoppingModel = shoppingModel;
   
    
    self.titleLb.text = shoppingModel.goods_name;
    
    if (shoppingModel.selectState)
    {
        self.checkBtn.selected=YES;
        self.selectState = YES;
        
    }else{
        self.selectState = NO;
        self.checkBtn.selected = NO;
    }

    self.shopNameLb.text = shoppingModel.goods_name;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.shopNameLb.attributedText];
    
  
    

    if (![shoppingModel.is_shipping isEqualToString:@"0"]) {
        
      
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image =[UIImage imageNamed:@"shopCart_FreeIcon"];
        textAttachment.bounds = CGRectMake(0, -2, 30, textAttachment.image.size.height*30/textAttachment.image.size.width);
        
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        NSRange range = NSMakeRange(0, 1);
        
        [string insertAttributedString:textAttachmentString atIndex:range.location];//为用户指定要插入图片的位置
        
        NSString *kongge =@" ";
        NSAttributedString  * konggestr =[[NSAttributedString alloc] initWithString:kongge];
  
        NSRange range1 = NSMakeRange(1, 2);
        [string insertAttributedString:konggestr atIndex:range1.location];

    }
    
    
    
    if (![shoppingModel.is_gift isEqualToString:@"0"]) {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image =[UIImage imageNamed:@"shopCart_GiftIcon"];
        textAttachment.bounds = CGRectMake(0, -2, 30, textAttachment.image.size.height*30/textAttachment.image.size.width);
        
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSRange  range1 ,range2;
        if (![shoppingModel.is_shipping isEqualToString:@"0"]) {
            range1 = NSMakeRange(2, 3);
            range2 = NSMakeRange(3, 4);
        }
        else
        {
            range1 = NSMakeRange(0, 1);
            range2 = NSMakeRange(1, 2);
        }
      
        [string insertAttributedString:textAttachmentString atIndex:range1.location];//为用户指定要插入图片的位置
        
        NSString *kongge =@" ";
        NSAttributedString  * konggestr =[[NSAttributedString alloc] initWithString:kongge];
        
  
        [string insertAttributedString:konggestr atIndex:range2.location];
        
    }
    
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    self.shopNameLb.attributedText = string;
    
    CGSize size = [self.shopNameLb sizeThatFits:CGSizeMake(kScreenWidth - kWidth(50)- kScreenWidth/5 - KLeft*2, MAXFLOAT)];
    
    if(size.height >45)
        size.height = 45;
    _shopNameLb.sd_layout
    .heightIs(size.height);
    
    
    self.shopNameLb2.attributedText =  string;
    _shopNameLb2.sd_layout
    .heightIs(size.height);
    
    self.priceLb.text = shoppingModel.goods_price;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.priceLb.text]];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(13) range:NSMakeRange(0,1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,1)];
    self.priceLb.attributedText = str;
    CGSize size1 = [self.priceLb sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    self.priceLb.sd_layout
    .widthIs(size1.width);
    
    
    
    [self.shopImageV sd_setImageWithURL:[NSURL URLWithString:shoppingModel.img_thumb] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
    
    
    self.addNumberView.numberString = shoppingModel.goods_number;

    self.numberTitleLb.text =[NSString stringWithFormat:@"x%@",shoppingModel.goods_number];
}
- (UIView *)titleV
{
    if (!_titleV) {
        _titleV = [UIView new];
        [_titleV setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];
    }
    return _titleV;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = DefaultFontSize(15);
        [_titleLb setTextAlignment:NSTextAlignmentLeft];
    }
    return _titleLb;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setBackgroundColor:[UIColor clearColor]];
        [_editBtn setTitle:@"编辑" forState:0];
        [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_editBtn setTitleColor:FontColor_black forState:0];
        _editBtn.titleLabel.font = DefaultFontSize(14);
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIView *)contentV
{
    if (!_contentV) {
        _contentV = [UIView new];
        [_contentV setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _contentV;
}
- (UIButton *)checkBtn
{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_choice"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_choice_selected"] forState:UIControlStateSelected];
        _checkBtn.imageEdgeInsets = UIEdgeInsetsMake(kWidth(15), kWidth(15), kWidth(15), kWidth(15));
        [_checkBtn addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}
- (UIImageView *)shopImageV
{
    if (!_shopImageV) {
        _shopImageV = [[UIImageView alloc]init];
        [_shopImageV setImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
        _shopImageV.layer.cornerRadius =2;
        _shopImageV.layer.masksToBounds =YES;
        _shopImageV.layer.borderWidth= SINGLE_LINE_WIDTH;
        _shopImageV.layer.borderColor = RGBACOLOR(220, 220, 220, 0.8).CGColor;

    }
    return _shopImageV;
}
- (UIView *)detailsV
{
    if (!_detailsV) {
        _detailsV = [UIView new];
        [_detailsV setBackgroundColor:[UIColor clearColor]];
    }
    return _detailsV;
}
- (UILabel *)shopNameLb
{
    if (!_shopNameLb) {
        _shopNameLb = [UILabel new];
        _shopNameLb.text = @"爱的日志玫瑰水润蚕丝面膜";
        _shopNameLb.font = DefaultFontSize(15);
        _shopNameLb.numberOfLines = 0;
        _shopNameLb.lineBreakMode = NSLineBreakByWordWrapping;
 
    }
    return _shopNameLb;
}
- (UILabel *)shopNameLb2
{
    if (!_shopNameLb2) {
        _shopNameLb2 = [UILabel new];
        _shopNameLb2.text = @"爱的日志玫瑰水润蚕丝面膜";
        _shopNameLb2.font = DefaultFontSize(15);
        _shopNameLb2.numberOfLines = 0;
        _shopNameLb2.lineBreakMode = NSLineBreakByWordWrapping;
        
    }
    return _shopNameLb2;
}
- (UILabel *)shopTypeLb
{
    if (!_shopTypeLb) {
        _shopTypeLb = [UILabel new];
        _shopTypeLb.font = DefaultFontSize(13);
        _shopTypeLb.textColor  = FontColor_gary;
    }
    return _shopTypeLb;
}
- (UILabel *)priceLb
{
    if (!_priceLb) {
        _priceLb = [[UILabel alloc]init];
        _priceLb.textColor = NavigationBackgroundColor;
        _priceLb.text = @"￥123.00";
        _priceLb.textAlignment = NSTextAlignmentLeft;
        _priceLb.font = DefaultFontSize(17);
       
        

    }
    return _priceLb;
}

- (UILabel *)numberTitleLb
{
    if (!_numberTitleLb) {
        
        _numberTitleLb = [UILabel new];
        _numberTitleLb.text = @"x1";
        _numberTitleLb.textColor = [UIColor darkGrayColor];
        _numberTitleLb.textAlignment =NSTextAlignmentLeft;
        _numberTitleLb.font = DefaultFontSize(15);
    }
    return _numberTitleLb;
}
-(UIView *)editV
{
    if (!_editV) {
        _editV = [UIView new];
        [_editV setBackgroundColor:[UIColor clearColor]];
    }
    return _editV;
}
- (AddNumberView *)addNumberView
{
    if (!_addNumberView) {
        _addNumberView = [[AddNumberView alloc]initWithFrame:CGRectMake(0,0, 100, 25)];
        _addNumberView.delegate = self;
        _addNumberView.backgroundColor = [UIColor clearColor];
    }
    return _addNumberView;
}
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundColor:[UIColor redColor]];
        [_deleteBtn setTitle:@"删除" forState:0];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:0];
        _deleteBtn.titleLabel.font = DefaultFontSize(14);
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _deleteBtn;
}
- (UILabel *)is_giftLb
{
    if (!_is_giftLb) {
        _is_giftLb = [UILabel new];
        _is_giftLb.layer.cornerRadius =3;
        _is_giftLb.layer.masksToBounds = YES;
        [_is_giftLb setBackgroundColor:NavigationBackgroundColor];
        _is_giftLb.textColor = [UIColor whiteColor];
        _is_giftLb.font =  DefaultFontSize(12);
        _is_giftLb.textAlignment = NSTextAlignmentCenter;
        _is_giftLb.text = @"赠品";
        _is_giftLb.width = 36;
        _is_giftLb.height = 15;
    }
    return _is_giftLb;
}
- (UILabel *)is_shoppingLb
{
    if (!_is_shoppingLb) {
        _is_shoppingLb = [UILabel new];
        _is_shoppingLb.layer.cornerRadius =3;
        _is_shoppingLb.layer.masksToBounds = YES;
        [_is_shoppingLb setBackgroundColor:NavigationBackgroundColor];
        _is_shoppingLb.textColor = [UIColor whiteColor];
        _is_shoppingLb.font =  DefaultFontSize(12);
        _is_shoppingLb.textAlignment = NSTextAlignmentCenter;
        _is_shoppingLb.text = @"免邮";
        _is_shoppingLb.width = 36;
        _is_shoppingLb.height = 15;
    }
    return _is_shoppingLb;
}
@end

//
//  DetailTabView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "DetailTabView.h"
#import "CommunityTool.h"

@implementation DetailTabView

- (UILabel *)cartNumLb
{
    if (!_cartNumLb) {
        _cartNumLb = [UILabel new];
        [_cartNumLb setBackgroundColor:NavigationBackgroundColor];
        [_cartNumLb setFont:DefaultFontSize(8)];
        [_cartNumLb setTextColor:[UIColor whiteColor]];
        _cartNumLb.layer.cornerRadius = 5;
        _cartNumLb.layer.masksToBounds = YES;
        
        _cartNumLb.textAlignment = NSTextAlignmentCenter;
    }
    return _cartNumLb;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel * linelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SINGLE_LINE_WIDTH)];
        [linelabel setBackgroundColor:ShiXianColor];
        [self addSubview:linelabel];
        //喜欢
        
        loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loveButton.frame =CGRectMake(0, 0, self.frame.size.width/6, self.frame.size.height);
        [loveButton setImage:[UIImage imageNamed:@"LoveNomal"] forState:UIControlStateNormal];
        [loveButton setImage:[UIImage imageNamed:@"LoveSelected"] forState:UIControlStateSelected];
        
        [loveButton setTitle:@"喜欢" forState:UIControlStateNormal];
        loveButton.titleLabel.font = DefaultFontSize(12);
        [loveButton setTitleColor:FontColor_black forState:UIControlStateNormal];
       
        loveButton.imageEdgeInsets = UIEdgeInsetsMake(8,loveButton.width/2-10,loveButton.height-28,loveButton.width/2-10);
       
        CGFloat xxxx = [loveButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : DefaultFontSize(20)}].width;
        loveButton.titleEdgeInsets = UIEdgeInsetsMake(30,-xxxx,3,0);
        
        [self addSubview:loveButton];
        
        [loveButton addTarget:self action:@selector(loveBtnClick) forControlEvents:UIControlEventTouchDown];
        
        
        
        
        UIButton* cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cartBtn.frame =CGRectMake(self.frame.size.width/6, 0, self.frame.size.width/6, self.frame.size.height);
        [cartBtn setImage:[UIImage imageNamed:@"cartIcon"] forState:UIControlStateNormal];
        cartBtn.imageEdgeInsets = UIEdgeInsetsMake(8,cartBtn.width/2-10,cartBtn.height-28,cartBtn.width/2-10);

        [cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
        cartBtn.titleLabel.font = DefaultFontSize(12);
        [cartBtn setTitleColor:FontColor_black forState:UIControlStateNormal];
         cartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat xxxxxxx = [cartBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : DefaultFontSize(13)}].width;
        cartBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-xxxxxxx,3,0);
        [self addSubview:cartBtn];
        
        [cartBtn addTarget:self action:@selector(cartBtnClick) forControlEvents:UIControlEventTouchDown];
        
//        
//        [cartBtn addSubview:self.cartNumLb];
//        _cartNumLb.frame = CGRectMake(cartBtn.width/2, 8, 16, 10);
        
        
        UIView * line =[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/6-SINGLE_LINE_WIDTH, 0, SINGLE_LINE_WIDTH, self.frame.size.height)];
        [line setBackgroundColor:ShiXianColor];
        [self addSubview:line];
        //购物车
        
      
        
     
        
        
        //加入购物车
        
        UIButton * shopCart =[UIButton buttonWithType:UIButtonTypeCustom];
        shopCart.frame =CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
        [shopCart setBackgroundColor:RGBACOLOR(201, 133, 85, 1)];
        [shopCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shopCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        shopCart.titleLabel.font  =DefaultFontSize(16);
        [self addSubview:shopCart];
        [shopCart addTarget:self action:@selector(shopCartClick:) forControlEvents:UIControlEventTouchDown];
        
        //立即购买
        UIButton *buyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame =CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, self.frame.size.height);
        [buyBtn setBackgroundColor:NavigationBackgroundColor];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.titleLabel.font  =DefaultFontSize(16);
        [self addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

-(void)setGoodModel:(GoodModel *)goodModel
{
    _goodModel = goodModel;
   
    if ([goodModel.is_like isEqualToString:@"1"]) {
        [loveButton setSelected:YES];
    }else
         [loveButton setSelected:NO];
   
    
}
-(void)buyBtnClick:(UIButton*)button
{
   
    _DetailTabViewBlock3();
}
-(void)shopCartClick:(UIButton*)button
{
 
    _DetailTabViewBlock2();
}
-(void)cartBtnClick
{

    _DetailTabViewBlock1();
}
-(void)loveBtnClick
{
 
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [CommunityTool likeCommunity:@"/digg" params:@{@"id":self.goodModel.id,@"type":@"0"} success:^(id obj) {
        [hud hide:YES];
        [self changeCollectButton:obj];
    } failure:^(id obj) {
        [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            
            
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
               [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            
        }
        
        
    }];
}

-(void)changeCollectButton:(id)obj
{
    loveButton.selected=    [[obj objectForKey:@"is_collect"] isEqualToNumber:[NSNumber numberWithLong:0]]  ? NO: YES;

}



-(void)drawRect:(CGRect)rect
{
    
}
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

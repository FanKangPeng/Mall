//
//  OrderTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "OrderTableViewCell.h"

#define ORDERCELL_HEIGHT 100

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)dict
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initViewWithDict:dict];
    return  self;
}
-(void)initViewWithDict:(NSDictionary* )dict
{
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ORDERCELL_HEIGHT/2)];
    [self.contentView addSubview:view1];
    UIImageView * orderImage =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/6-40, ORDERCELL_HEIGHT/4-10, 25, 25)];
    [orderImage setImage:[UIImage imageNamed:@"userInfo_order_icon"]];
    [view1 addSubview:orderImage];
    
    UILabel * orderLabel  =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/6-10, ORDERCELL_HEIGHT/4-10, 60, 25)];
    orderLabel.text=@"我的订单";
    orderLabel.textColor= FontColor_black;
    orderLabel.font =DefaultFontSize(15);
    [view1 addSubview:orderLabel];
    
    UIButton * nextButton =[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton .frame  =CGRectMake(kScreenWidth-35,ORDERCELL_HEIGHT/4-15, 30, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchDown];
    [view1 addSubview:nextButton];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonClick)];
    [view1 addGestureRecognizer:tap];
    
    
    UILabel * line  =[[UILabel alloc] initWithFrame:CGRectMake(0, ORDERCELL_HEIGHT/2, kScreenWidth, SINGLE_LINE_WIDTH)];
    [line setBackgroundColor:ShiXianColor];
    [self addSubview:line];
    
    NSArray * labelTexts =@[@"待付款",@"待收货",@"退款/退货"];
    for (int i = 0; i<3; i++)
    {
        UIView * View =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/3 * i, ORDERCELL_HEIGHT/2-SINGLE_LINE_WIDTH, kScreenWidth/3, ORDERCELL_HEIGHT/2-SINGLE_LINE_WIDTH)];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapClick:)];
        View.tag = 1000+ i;
        [View addGestureRecognizer:tap];
        [self addSubview:View];
        
        CGSize fontSize = [labelTexts[i] sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(15)}];
        CGFloat contentWidth =  fontSize.width + 25;
        
        UIImageView * iconImage =[[UIImageView alloc] initWithFrame:CGRectMake(View.frame.size.width/2-contentWidth/2, View.frame.size.height/2-10, 20, 20)];
        iconImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"userInfo_order_iconImage_%d",i]];
        [View addSubview:iconImage];
        
        UILabel * iconLabel =[[UILabel alloc] initWithFrame:CGRectMake(View.frame.size.width/2-contentWidth/2+25, View.frame.size.height/2-13, fontSize.width, 25)];
        iconLabel.font =DefaultFontSize(15);
        iconLabel.textColor=[UIColor colorWithRed:102.00/255.00 green:102.00/255.00 blue:102.00/255.00 alpha:1];
        iconLabel.text=labelTexts[i];
        [View addSubview:iconLabel];
        
        UILabel * shuxian  =[[UILabel alloc] initWithFrame:CGRectMake(View.frame.size.width-SINGLE_LINE_WIDTH, View.frame.size.height/2-10, SINGLE_LINE_WIDTH, 20)];
        [shuxian setBackgroundColor:ShiXianColor];
        [View addSubview:shuxian];
        
        if(i==2)
        {
            [shuxian setBackgroundColor:[UIColor clearColor]];
        }
    }
    

}

-(void)TapClick:(UITapGestureRecognizer*)tap
{
    _OrderCellBlock(tap.view.tag);
 
}
-(void)nextButtonClick
{
    _OrderCellBlock(0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

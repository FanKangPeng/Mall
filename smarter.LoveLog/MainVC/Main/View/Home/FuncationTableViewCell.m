//
//  FuncationTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/8.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FuncationTableViewCell.h"


#define ImageOriginWidth  kScreenWidth/9
#define ImageOriginY  kScreenWidth*30/750-5

@implementation FuncationTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setFuncationArray:(NSArray *)funcationArray
{

    self.nameArr =[NSMutableArray arrayWithArray:funcationArray];
    [self initView];
}
-(void)initView
{

    UIView*_midView  =[[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenWidth/2.3)];
    [_midView setBackgroundColor:[UIColor whiteColor]];
    
    UIView * backView  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _midView.frame.size.height-7)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [_midView addSubview:backView];
     NSArray * imageAttay  =@[@"main_middle_button_firstOrder",@"main_middle_button_gift",@"main_middle_button_cart",@"main_middle_button_search",@"main_middle_button_redPacket",@"main_middle_button_freight",@"main_middle_button_safety",@"main_middle_button_pay"];
    
    NSUInteger tga = 0;
    for (int i =0; i<2; i++)
    {
        for (int j=0; j<4; j++) {
           
            Function * function =self.nameArr[tga];
            UIView * view =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/4*j,backView.frame.size.height/2*i,kScreenWidth/4,backView.frame.size.height/2)];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - ImageOriginWidth/2,ImageOriginY,ImageOriginWidth,ImageOriginWidth)];
            UIImage * cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:function.icon];
            if (cacheImage) {
                imageView.image = cacheImage;
            }
            else
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",function.icon]] placeholderImage:[UIImage imageNamed:imageAttay[tga]]];
                [[SDImageCache sharedImageCache] storeImage:imageView.image forKey:function.icon];
            }
            [view addSubview:imageView];
            
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-20, view.frame.size.width, 20)];
            [label setFont:DefaultFontSize(13)];
            [label setTextColor:[UIColor colorWithRed:102.00/255.00 green:102.00/255.00 blue:102.00/255.00 alpha:1]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:function.name];
            [view addSubview:label];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            view.tag=tga;
            [view addGestureRecognizer:tap];
            [backView addSubview:view];
             tga ++;
        }
    }
    
    [self setupAutoHeightWithBottomView:_midView bottomMargin:0];
    [self addSubview:_midView];
}
-(void)tapClick:(UITapGestureRecognizer*)tap
{
    Function * function = self.nameArr[tap.view.tag];
    _CarouselCellBtnBlcok(function.action,function.param);
}

@end

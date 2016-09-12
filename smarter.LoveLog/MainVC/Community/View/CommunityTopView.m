//
//  CommunityTopView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityTopView.h"
#import "Slider.h"
#import "Function.h"
#define  ImageOriginWidth kScreenWidth*0.125
#define ImageOriginY ImageOriginWidth/4

@implementation CommunityTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if(self)
    {
        UIView * view1  =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth/2+kScreenWidth*0.25, kScreenWidth, 40)];
        UILabel * label1 =[[UILabel alloc] initWithFrame:CGRectMake(view1.frame.size.width/2-50, 0, 100, 40)];
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label1 setFont:DefaultFontSize(16)];
        [label1 setTextColor:FontColor_gary];
        [label1 setText:@"热门推荐"];
        [view1 addSubview:label1];
        
        UILabel * leftLine =[[UILabel alloc] initWithFrame:CGRectMake(15, view1.frame.size.height/2, view1.frame.size.width/2-65, SINGLE_LINE_WIDTH)];
        [leftLine setBackgroundColor:[UIColor colorWithRed:221.00/255.00 green:221.00/255.00 blue:221.00/255.00 alpha:1]];
        [view1 addSubview:leftLine];
        
        UILabel * rightLine =[[UILabel alloc] initWithFrame:CGRectMake(view1.frame.size.width/2+50, view1.frame.size.height/2, view1.frame.size.width/2-65, SINGLE_LINE_WIDTH)];
        [rightLine setBackgroundColor:[UIColor colorWithRed:221.00/255.00 green:221.00/255.00 blue:221.00/255.00 alpha:1]];
        [view1 addSubview:rightLine];
        [self addSubview:view1];

    }
    return self;
}
-(void)setFuncationArray:(NSArray *)funcationArray
{
    _nameArr =[NSMutableArray arrayWithArray:funcationArray];
 
    UIView* _midView  =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth/2, kScreenWidth, kScreenWidth*0.25)];
    [_midView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray * imageAttay  =@[@"community_notice",@"community_experience",@"community_beautiful",@"community_hodgepodge"];
    NSUInteger tga = 0;
    for (int j=0; j<4; j++)
    {
        Function * funcation = _nameArr[j];
        UIView * view =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/4*j,0,kScreenWidth/4,_midView.frame.size.height)];
        
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - ImageOriginWidth/2,ImageOriginY,ImageOriginWidth,ImageOriginWidth)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:funcation.icon] placeholderImage:[UIImage imageNamed:imageAttay[j]]];
        [view addSubview:imageView];
        
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, ImageOriginY*2 +ImageOriginWidth, view.frame.size.width, ImageOriginY)];
        [label setFont:DefaultFontSize(13)];
        [label setTextColor:[UIColor colorWithRed:102.00/255.00 green:102.00/255.00 blue:102.00/255.00 alpha:1]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:funcation.name];
        [view addSubview:label];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        
        view.tag=tga;
        tga ++;
        [view addGestureRecognizer:tap];
        [_midView addSubview:view];
        
    }
    
    [self addSubview:_midView];

}
-(void)setSliderArray:(NSArray *)sliderArray
{
   NSMutableArray * imageArr =[NSMutableArray array];
    for (Slider* slider  in sliderArray) {
        [imageArr addObject:slider.image_url];
    }
    
    FKPScrollerView  *picView = [FKPScrollerView picScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2) WithImageUrls:imageArr];
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        Slider * slider =sliderArray[index];
        if(slider)
        {
            _communtityTopBlock(slider.action,slider.param);
        }
    }];
    
    picView.AutoScrollDelay = 3.0f;
    [self addSubview:picView];
    
   
    
}


-(void)tapClick:(UITapGestureRecognizer*)tap
{
    Function * funcation =  _nameArr[tap.view.tag];
    _communtityTopBlock(funcation.action,funcation.param);
}


@end

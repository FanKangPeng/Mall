//
//  NoDataView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

-(instancetype)init
{
    self =[super initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
    if(self)
    {
        [self setBackgroundColor:BackgroundColor];
      
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if(self)
    {
      
        [self setBackgroundColor:BackgroundColor];

       
    }
    return self;
    
    
}
-(void)setCAPION:(NSString *)CAPION
{
    UIImage * backImage= [UIImage imageNamed:@"error_nodata"];
    UIImageView * imageView  =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-backImage.size.width/2, 40, backImage.size.width, backImage.size.height)];
    imageView.image = backImage;
    [self addSubview:imageView];
    
    imageView.center =CGPointMake( [UIApplication sharedApplication].keyWindow.center.x,[UIApplication sharedApplication].keyWindow.center.y/2);

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, kScreenWidth, 30)];
    label.text =CAPION;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    
    [self addSubview:label];
    
    if ([CAPION isEqualToString:@"暂无评论"]) {
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom+10, kScreenWidth, 30)];
        label1.text =@"快来抢沙发吧";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor grayColor];
        
        [self addSubview:label];
    }
}

@end

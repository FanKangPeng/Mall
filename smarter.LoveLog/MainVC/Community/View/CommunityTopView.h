//
//  CommunityTopView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FKPScrollerView.h"
typedef void(^CarouselCellBlock)(NSString * sliderUrl);

@interface CommunityTopView : UIView
@property (nonatomic ,strong)NSArray * sliderArray;
@property (nonatomic ,strong)NSArray * funcationArray;
@property (nonatomic ,strong)NSMutableArray * nameArr;
@property (nonatomic,copy)void(^communtityTopBlock)(NSString * action,NSString * param);


@end

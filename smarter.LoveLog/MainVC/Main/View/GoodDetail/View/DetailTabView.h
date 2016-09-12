//
//  DetailTabView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface DetailTabView : UIView
{
    UIButton * loveButton;
}

@property (nonatomic ,copy) UILabel *cartNumLb;



@property (nonatomic,strong)GoodModel * goodModel;

/**
 调整购物车
 */
@property (nonatomic,copy)void(^DetailTabViewBlock1)();
/**
 购物车
 */
@property (nonatomic,copy)void(^DetailTabViewBlock2)();
/**
 立即购买
 */
@property (nonatomic,copy)void(^DetailTabViewBlock3)();


@property (nonatomic)BOOL  isDanPin;
@end

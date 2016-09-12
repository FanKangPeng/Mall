//
//  NetFaileView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/9.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetFaileView : UIView


@property(nonatomic,copy)void(^NetFaileReloadBlock)();


@property(nonatomic,copy)void(^StrollButtonBlock)();

/**
 初始化网络加载失败页面
 */
-(instancetype)initNetFaileViewWithFrame:(CGRect)frame;
/**
 购物车页面数据为空
 */
-(instancetype)initShopCartNullView:(CGRect)frame;
/**
 图片加载失败
 */
-(instancetype)initLoadImageFaile;
@end

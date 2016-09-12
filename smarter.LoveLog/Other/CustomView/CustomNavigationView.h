//
//  CustomNavigationView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/2.
//  Copyright © 2015年 FanKing. All rights reserved.
//



#import <UIKit/UIKit.h>

#import "ShareModel.h"
@interface CustomNavigationView : UIView
@property(nonatomic,strong) ShareModel * shareModel;
@property(nonatomic,strong)NSDictionary * shareDict;
/**
 初始化导航view
 */
-(void)initViewWithTitle:(NSString *)title andBack:(NSString*)backName andRightName:(NSString*)rightName;

/**
 初始化透明导航view
 */
-(void)initViewWithTitle:(NSString *)title Back:(NSString*)backName andRightName:(NSString*)rightName andAlpha:(CGFloat)Alpha;

@property(nonatomic,copy) void(^CustomNavigationLeftImageBlock)();

@property(nonatomic,copy)void(^CustomNavigationRightImageBlock)();

@property(nonatomic,copy)void(^CustomNavigationCustomLeftBtnBlock)();

@property(nonatomic,copy)void(^CustomNavigationCustomRightBtnBlock)(UIButton *rightBtn);


@end

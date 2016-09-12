//
//  TypeView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeView : UIView

@property (nonatomic ,copy) void (^typeViewButtonBlock)(NSUInteger tag);
@property (nonatomic ,assign) CGFloat typeViewHeight;
@property (nonatomic ,assign) NSUInteger selectedIndex;


- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)arr title:(NSString *)title;

@end

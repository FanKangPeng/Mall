//
//  FillInOrderTabView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FillInOrderTabView : UIView
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,strong)UILabel * sumLabel;
@property(nonatomic,strong)UIButton * fillinOrderButton;
@property(nonatomic,copy)void(^FillInOrderButtonBlovk)();

@end

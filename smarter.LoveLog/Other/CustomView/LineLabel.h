//
//  LineLabel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineLabel : UILabel
@property (assign, nonatomic) BOOL strikeThroughEnabled; // 是否画线

@property (strong, nonatomic) UIColor *strikeThroughColor; // 画线颜色
@end

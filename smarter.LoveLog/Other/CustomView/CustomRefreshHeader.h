//
//  CustomRefreshHeader.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/29.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "DACircularProgressView.h"

@interface CustomRefreshHeader : MJRefreshHeader
@property (weak, nonatomic) UILabel *label;
@property (strong, nonatomic) DACircularProgressView *logo;
@property(nonatomic,copy)NSArray * something;

@property(nonatomic,strong)NSTimer * timer;

@end

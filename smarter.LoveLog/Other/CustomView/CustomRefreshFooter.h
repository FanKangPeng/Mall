//
//  CustomRefreshFooter.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "DACircularProgressView.h"
@interface CustomRefreshFooter : MJRefreshBackFooter
@property (weak, nonatomic) UILabel *label;
@property (strong, nonatomic) DACircularProgressView *logo;
@property(nonatomic,copy)NSArray * something;
@property (nonatomic,assign) CGFloat scrollerViewY;
@property(nonatomic,strong)NSTimer * timer;
@property (strong, nonatomic) UIImageView *loadingImage;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

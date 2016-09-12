//
//  LaunchViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController
@property (nonatomic, strong) UIImageView *launchImage;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *Lb;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger timeCount;
@property (nonatomic, copy) NSString * link_url;
@property (nonatomic ,strong) UIButton *timerBtn;
@end

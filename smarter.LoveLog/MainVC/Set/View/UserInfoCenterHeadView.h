//
//  UserInfoCenterHeadView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface UserInfoCenterHeadView : UIImageView
@property(nonatomic,strong)UILabel * nameLabel;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic,copy)void(^PortraitImageViewBlock)();
@property (nonatomic,copy) void(^LoginButtonBlock)();
@property (nonatomic,copy)void(^SetButtonBlock)();
@property (nonatomic,strong)UserInfoModel * userInfo;
@property (nonatomic ,strong) UserInfoModel *cacheUserInfo;
@end

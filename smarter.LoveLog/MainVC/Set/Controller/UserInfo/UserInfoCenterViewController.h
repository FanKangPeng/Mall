//
//  UserInfoCenterViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoCenterHeadView.h"
#import "UserInfoModel.h"

@interface UserInfoCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * mainView;
@property (nonatomic,strong)UserInfoCenterHeadView * headView;
@property(nonatomic,strong)UserInfoModel * userInfoModel;



@end

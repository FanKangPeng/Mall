//
//  AboutViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface AboutViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) CustomNavigationView * setNavigationView;
@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UILabel * namelable;
@property(nonatomic,strong)UILabel * versionsLabel;
@property(nonatomic,strong)UIView * backView;
@end

//
//  PostsCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
@interface PostsCell : UITableViewCell<MBProgressHUDDelegate>
@property(nonatomic,strong)CommunityModel * communityModel;




@property(nonatomic,strong)UILabel * contentLable;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;


@property(nonatomic,strong)UIButton * commentButton;

@property(nonatomic,strong)UIView * imageBacgroundkView;

@property(nonatomic,strong)UIView * backView;

@property(nonatomic,copy)void(^PostsCellBlock)(NSString * post_id);

@end

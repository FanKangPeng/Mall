//
//  CommunityDetailTopView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityDetailModel.h"

@interface CommunityDetailTopView : UIView<MBProgressHUDDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIImageView*portraitImageView;
@property (nonatomic ,strong) UIImageView *posterImageView;
@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property(nonatomic,strong)CommunityDetailModel * communityDeatilModel;


@end

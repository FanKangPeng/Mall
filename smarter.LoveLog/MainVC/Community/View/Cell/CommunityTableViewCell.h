//
//  CommunityTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/18.
//  Copyright © 2015年 FanKing. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Award.h"
#import "CommunityModel.h"
#import "CustomAlertView.h"
@interface CommunityTableViewCell : UITableViewCell<MBProgressHUDDelegate,CustomAlertViewDelegate>
{
    CGFloat height;
}

@property(nonatomic,strong)CommunityModel * communityModel;



@property(nonatomic,strong)UIImageView *portraitImageView;
@property(nonatomic,strong)UIButton *awardButton;
@property(nonatomic,strong)UILabel *contentLable;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton * hot;
@property(nonatomic,strong)UIButton * Essence;
@property(nonatomic,strong)NSMutableArray * imageArr;
@property(nonatomic,strong)UIButton * shareButton;
@property(nonatomic,strong)UIButton * commentButton;
@property(nonatomic,strong)UIButton * loveButton;
@property(nonatomic,strong)UIView * imageBacgroundkView;
@property(nonatomic,strong)UIView * bottonView;


@property(nonatomic,copy) NSString * rewardCount;

/**评论block*/
@property(nonatomic,copy) void (^commentBlock)(NSString * community_id);

@property (nonatomic ,copy) void (^commentLoginBlock)();
@end

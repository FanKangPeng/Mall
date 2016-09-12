//
//  CommunityCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community_CommentModel.h"
#import <MLLabel/MLLabel.h>
#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>

#import <MLTextAttachment.h>
@interface CommunityCell : UITableViewCell

@property (nonatomic,strong) UIImageView*portraitImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) MLLabel * concentLabel;
@property (nonatomic,strong) UIButton * likeButton;
@property(nonatomic,strong)Community_CommentModel * commentModel;

@property (nonatomic ,strong) NSDictionary *faceDict;

@property (nonatomic ,strong)  MLExpression *exp;

@property (nonatomic ,copy) void (^CommunityCellBlock)();
@end

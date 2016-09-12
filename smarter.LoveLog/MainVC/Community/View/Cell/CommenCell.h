//
//  CommenCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community_CommentModel.h"
@interface CommenCell : UITableViewCell
@property (nonatomic,strong) UIImageView*portraitImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * concentLabel;

@property(nonatomic,strong)Community_CommentModel * commentModel;


@end

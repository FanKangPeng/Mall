//
//  NotificationCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"
@interface NotificationCell : UITableViewCell
@property(nonatomic,strong)NotificationModel * model;
@property(nonatomic,strong)UIImageView * icomImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * contentLabel;

@end

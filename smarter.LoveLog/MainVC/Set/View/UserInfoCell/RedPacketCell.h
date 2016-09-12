//
//  RedPacketCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
@interface RedPacketCell : UITableViewCell
@property(nonatomic,strong)RedPacketModel * redPacketModel;
@property(nonatomic,strong)UIImageView * backImage;
@property(nonatomic,strong)UILabel * priceLabel;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * overtimeLabel;
@property (nonatomic ,strong)UIView * packetView;
@property (nonatomic ,strong) UIImageView *selectImg;
@property (nonatomic ,copy) NSString *imageName;
@end

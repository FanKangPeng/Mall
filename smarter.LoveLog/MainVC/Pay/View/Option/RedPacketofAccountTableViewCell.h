//
//  RedPacketofAccountTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketofAccountDelegate <NSObject>

- (void)usedBonus:(NSDictionary *)data;

@end

@interface RedPacketofAccountTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * distributionLabel;
@property(nonatomic,strong)UILabel * TypeLabel;

@property (nonatomic ,strong) NSDictionary * bonusDict;
@property (nonatomic ,weak) id <RedPacketofAccountDelegate> RedPacketofAccountDelegate;

@end


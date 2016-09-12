//
//  EventTableViewCell.h
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Action.h"



@interface EventTableViewCell : UITableViewCell
@property (nonatomic,strong) NSArray * actionArr;
@property(nonatomic,strong)UIImageView * action1;
@property(nonatomic,strong)UIImageView * action2;
@property(nonatomic,strong)UIImageView * action3;

@property (nonatomic,copy)void(^ActionBlock)(NSString * action,NSString * param);



@end

//
//  NotificationModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * nid;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * is_read;

@end

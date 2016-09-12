//
//  Community_CommentModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Community_CommentModel : NSObject
@property(nonatomic,strong) NSString * cmt_id;
@property(nonatomic,strong) NSString * parent_id;
@property(nonatomic,strong) NSString * cmt_rank;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * like_count;
@property(nonatomic,strong) NSString * add_time;
@property(nonatomic,strong) NSDictionary * user;
@property(nonatomic,copy)NSString * is_digg;
@property(nonatomic,copy)NSString * digg_count;
@end

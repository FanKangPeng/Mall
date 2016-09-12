//
//  MyCommentModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject
@property(nonatomic,copy)NSString * cmt_id;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * like_count;
@property(nonatomic,copy)NSDictionary * object;
@property(nonatomic,copy)NSString * com_rank;
@property(nonatomic,copy)NSDictionary * user;
@property(nonatomic,copy)NSString * parent_id;
@property(nonatomic,copy)NSString * add_time;

@end

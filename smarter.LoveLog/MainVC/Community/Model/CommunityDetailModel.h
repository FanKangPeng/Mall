//
//  CommunityDetailModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/9.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityDetailModel : NSObject
@property(nonatomic,copy) NSString * id;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * url;
@property(nonatomic,copy) NSString * content;
@property(nonatomic,copy) NSString * cat_name;
@property(nonatomic,copy) NSString * cat_url;
@property(nonatomic,copy) NSString * like_count;
@property(nonatomic,copy) NSString * click_count;
@property(nonatomic,copy) NSString * cmt_count;
@property(nonatomic,copy) NSString * is_like;
@property(nonatomic,copy) NSString * add_time;
@property(nonatomic,copy) NSString * is_best;
@property(nonatomic,copy) NSString * is_hot;
@property(nonatomic,copy) NSString * audit;
@property(nonatomic,copy) NSDictionary * share;
@property(nonatomic,copy) NSString * reward_count;
@property(nonatomic,copy) NSString * cat_id;
@property(nonatomic,copy) NSString * collect_count;
@property(nonatomic,copy) NSString * is_collect;

@property(nonatomic,strong)NSDictionary * img;
@property(nonatomic,strong)NSDictionary * user;
@property(nonatomic,strong)NSArray * cmt;
@end

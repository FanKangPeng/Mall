//
//  CommunityTool.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/9.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallBack)(id obj);
@interface CommunityTool : NSObject
/**
 *获取论坛首页数据
 */
+(void)getCommunityViewDate:(NSString*)url success:(CallBack)success failure:(CallBack)failure;
/**
 *下啦刷新
 */
+(void)getCommunityMoreDate:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *获取论坛分类页数据
 */
+(void)getCommunityListDate:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *获取帖子详情数据
 */
+(void)getCommunityDate:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *打赏
 */
+(void)rewardCommunity:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *收藏
 */
+(void)likeCommunity:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *获取帖子评论
 */
+(void)getComment:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *添加帖子评论
 */
+(void)addComment:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *评论上拉刷新
 */
+(void)getCommentMoreDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure;
/**
 *获取我的评论
 */
+(void)getMyComment:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
/**
 *评论点赞
 */
+(void)commentTop:(NSString*)url  params:(NSDictionary*)params  success:(CallBack)success failure:(CallBack)failure;
@end

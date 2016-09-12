//
//  CommunityModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject
/**title*/
@property(nonatomic,copy) NSString * title;
/**描述文字*/
@property(nonatomic,copy) NSString * brief;
/**点赞数*/
@property(nonatomic,copy) NSString * like_count;
/**查看次数*/
@property(nonatomic,copy) NSString * click_count;
/**评论数量*/
@property(nonatomic,copy) NSString * cmt_count;
/**发布时间*/
@property(nonatomic,copy) NSString * add_time;
/**是否点赞*/
@property(nonatomic,copy) NSString * is_like;
/**帖子ID*/
@property(nonatomic,copy) NSString * id;
/**封面图片*/
@property(nonatomic,strong)NSDictionary * img;
/**发帖用户信息*/
@property(nonatomic,strong)NSDictionary * user;
/**是否精品*/
@property(nonatomic,copy) NSString * is_best;
/**是否热门*/
@property(nonatomic,copy) NSString * is_hot;
/**是否收藏*/
@property(nonatomic,copy) NSString * is_collect;
/**打赏数量*/
@property(nonatomic,copy) NSString *reward_count;
/**分享内容*/
@property(nonatomic,strong)NSDictionary * share;
/**分类名称*/
@property(nonatomic,copy)NSString * cat_name;
/**分类连接*/
@property(nonatomic,copy)NSString * cat_url;
/**被收藏次数*/
@property(nonatomic,copy)NSString * collect_count;
@end




//
//  CommunityTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/9.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "CommunityTool.h"
#import "AFNetHttp.h"
#import "CommunityModel.h"
#import "Slider.h"
#import "Function.h"
#import "CommunityDetailModel.h"
#import "Community_CommentModel.h"
#import "MyCommentModel.h"
@implementation CommunityTool

+(void)commentTop:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)addComment:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)likeCommunity:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)rewardCommunity:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        success([response objectForKey:@"data"]);
    } failure:^(id error) {
        failure(error);
    }];
    
    
}


+(void)getMyComment:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        
        [weakSelf jsonAnalysWithMyCommentJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}

+(void)getComment:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
     
        [weakSelf jsonAnalysWithCommentJson:response Callback:success];
      
    } failure:^(id error) {
        failure(error);
    }];
}


+(void)getCommunityViewDate:(NSString *)url success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
   [AFNetHttp getData:url params:nil session:YES success:^(NSDictionary* response) {

        [weakSelf jsonAnalysWithCommunityViewJson:response Callback:success];

   } failure:^(id error) {
         failure(error);
   }];
}
+(void)getCommunityListDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
   [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {

        [weakSelf jsonAnalysWithCommunityListJson:response Callback:success];
  
   } failure:^(id error) {
         failure(error);
   }];
}
+(void)getCommentMoreDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        
        [weakSelf jsonAnalysWithCommentJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getCommunityMoreDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
 
        [weakSelf jsonAnalysWithCommunityListJson:response Callback:success];
  
    } failure:^(id error) {
         failure(error);
    }];
}
+(void)getCommunityDate:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
   
        [weakSelf jsonAnalysWithCommunityJson:response Callback:success];
    
    } failure:^(id error) {
         failure(error);
    }];
}
//解析communityView data
+(void)jsonAnalysWithCommunityViewJson:(id)json Callback:(CallBack)callBack
{
    NSMutableDictionary * communityDict =[NSMutableDictionary dictionary];
    NSMutableArray * communityArray =[NSMutableArray array];
    NSMutableArray * sliderArray =[NSMutableArray array];
    NSMutableArray * funcationArray =[NSMutableArray array];
    NSDictionary *dictionary =[json objectForKey:@"data"];
    for (id key in dictionary) {
        if([key isEqualToString:@"promote_posts"])
        {
            NSArray * communityArr =[dictionary objectForKey:key];
            for (NSDictionary * dict in communityArr) {
                CommunityModel * communityModel = [CommunityModel mj_objectWithKeyValues:dict];
                [communityArray addObject:communityModel];
            }
            [communityDict setObject:communityArray forKey:@"promote_posts"];
        }
        
        if([key isEqualToString:@"nav"])
        {
            NSArray * communityArr =[dictionary objectForKey:key];
            for (NSDictionary * dict in communityArr) {
                Function * funcation = [Function mj_objectWithKeyValues:dict];
                [funcationArray addObject:funcation];
                
            }
             [communityDict setObject:funcationArray forKey:@"nav"];
        }
        
        if([key isEqualToString:@"slider"])
        {
            NSArray * communityArr =[dictionary objectForKey:key];
            for (NSDictionary * dict in communityArr) {
                Slider * slider = [Slider mj_objectWithKeyValues:dict];
                [sliderArray addObject:slider];
                
            }
             [communityDict setObject:sliderArray forKey:@"slider"];
        }
    }
    callBack(communityDict);
    
}
//解析communityList data
+(void)jsonAnalysWithCommunityListJson:(id)json Callback:(CallBack)callBack
{
    NSMutableDictionary * communityDict =[NSMutableDictionary dictionary];
    NSMutableArray * communityArray =[NSMutableArray array];
    NSArray *array =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in array) {
        CommunityModel * communityModel = [CommunityModel mj_objectWithKeyValues:dictionary];
        [communityArray addObject:communityModel];
        [communityDict setObject:communityArray forKey:@"promote_posts"];
    }
    [communityDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callBack(communityDict);
}
//解析community data
+(void)jsonAnalysWithCommunityJson:(id)json Callback:(CallBack)callBack
{
        NSDictionary *dictionary =[json objectForKey:@"data"];
        CommunityDetailModel * detailModel =[CommunityDetailModel mj_objectWithKeyValues:dictionary];
        callBack(detailModel);
}
//解析帖子评论
+(void)jsonAnalysWithCommentJson:(id)json Callback:(CallBack)callBack
{
    NSMutableDictionary * commentDict =[NSMutableDictionary dictionary];
    NSMutableArray * commentArray =[NSMutableArray array];
    NSArray *array =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in array) {
        Community_CommentModel * commentModel = [Community_CommentModel mj_objectWithKeyValues:dictionary];
        [commentArray addObject:commentModel];
        [commentDict setObject:commentArray forKey:@"comment"];
    }
    [commentDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callBack(commentDict);
}
//解析我的评论
+(void)jsonAnalysWithMyCommentJson:(id)json Callback:(CallBack)callBack
{
    NSMutableDictionary * commentDict =[NSMutableDictionary dictionary];
    NSMutableArray * commentArray =[NSMutableArray array];
    NSArray *array =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in array) {
        MyCommentModel * commentModel = [MyCommentModel mj_objectWithKeyValues:dictionary];
        [commentArray addObject:commentModel];
        [commentDict setObject:commentArray forKey:@"comment"];
    }
    [commentDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callBack(commentDict);
}
@end

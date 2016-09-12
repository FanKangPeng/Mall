//
//  GoodsTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "GoodsTool.h"
#import "AFNetHttp.h"
#import "GoodModel.h"
#import "EstimateModel.h"
@implementation GoodsTool
+(void)postData:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary *response) {
        success(response);
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
+(void)getComment:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:YES success:^(NSDictionary* response) {
        
        [weakSelf jsonAnalysWithCommentJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getgoodDetail:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id json) {
        
        
        [weakSelf jsonAnalysisWithJson:json Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)jsonAnalysisWithJson:(id)json  Callback:(CallBack)callBack
{
    NSDictionary * dict = [json objectForKey:@"data"];
    GoodModel * googmodel =[GoodModel mj_objectWithKeyValues:dict];
    callBack(googmodel);
}
//解析帖子评论
+(void)jsonAnalysWithCommentJson:(id)json Callback:(CallBack)callBack
{
    NSMutableDictionary * commentDict =[NSMutableDictionary dictionary];
    NSMutableArray * commentArray =[NSMutableArray array];
    NSArray *array =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in array) {
        EstimateModel * commentModel = [EstimateModel mj_objectWithKeyValues:dictionary];
        [commentArray addObject:commentModel];
        [commentDict setObject:commentArray forKey:@"comment"];
    }
    [commentDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callBack(commentDict);
}

@end

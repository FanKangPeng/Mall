//
//  UserInfoTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "UserInfoTool.h"
#import "AFNetHttp.h"
#import "UserInfoModel.h"
#import "NotificationModel.h"
#import "OrderModel.h"
#import "MyKeyChainHelper.h"
#import "FMDBManager.h"
#import "RedPacketModel.h"
@implementation UserInfoTool
+ (void)pushThirdLoginData:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
       [weakSelf jsonAnalysWithThirdLoginJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)getRedPacketData:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        [self jsonAnalysWithRedPacketJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+ (void)userRedPacket:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        success(response);
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getCollect:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
   // __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        success(response);
      //  [weakSelf jsonAnalysWithCollectJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getOrder:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        [weakSelf jsonAnalysWithOrderJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getMessage:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
        [weakSelf jsonAnalysWithMessageJson:response Callback:success];
        
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)Login:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
    
        [weakSelf jsonAnalysWithLoginJson:response Callback:success];
    
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)userInfo:(NSString *)url params:(NSDictionary *)params success:(CallBack)success failure:(CallBack)failure
{
 
    [AFNetHttp getData:url params:params session:NO success:^(id response) {
        
     success([response objectForKey:@"data"]);

    } failure:^(id error) {
        failure(error);
    }];
}
//解析第三方登录的用户信息
+(void)jsonAnalysWithThirdLoginJson:(id)json Callback:(CallBack)callback
{
    NSDictionary * dict =[json objectForKey:@"data"];
    NSDictionary * sessionDict =  [dict objectForKey:@"session"];
    NSDictionary * dict1  = @{@"sid":[sessionDict objectForKey:@"sid"],@"uid":[sessionDict objectForKey:@"uid"]};
    [self saveSessionToKeyChain:dict1];
    NSDictionary * userDict =[dict objectForKey:@"user"];
    NSString *complete = [NSString stringWithFormat:@"%@",[dict objectForKey:@"complete"]];
    NSDictionary * callBackDict = @{@"complete":complete,@"userDict":userDict};
    callback(callBackDict);
}
//解析用户信息
+(void)jsonAnalysWithLoginJson:(id)json Callback:(CallBack)callback
{
    NSDictionary * dict =[json objectForKey:@"data"];
    //获取到session时 把session存储到keyChain中
    NSDictionary * sessionDict =  [dict objectForKey:@"session"];
    
    NSDictionary * dict1  = @{@"sid":[sessionDict objectForKey:@"sid"],@"uid":[sessionDict objectForKey:@"uid"]};
    [self saveSessionToKeyChain:dict1];
    
    NSDictionary * userDict =[dict objectForKey:@"user"];
    callback(userDict);
}
#pragma mark --获取到session时 把session存储到keyChain中
+(void)saveSessionToKeyChain:(NSDictionary*)session
{
 
        //1:存储用户信息
    [MyKeyChainHelper saveSession:session andSessionService:KeyChain_SessionKey];
       
    [FMDBManager postData];
  

}
//解析消息
+(void)jsonAnalysWithMessageJson:(id)json Callback:(CallBack)callback
{
    NSMutableDictionary * messageDict =[NSMutableDictionary dictionary];
    NSMutableArray * messageArr =[NSMutableArray array];
    NSArray * arr =[json objectForKey:@"data"];
    for (NSDictionary * dict in arr) {
        NotificationModel * model = [NotificationModel mj_objectWithKeyValues:dict];
        [messageArr addObject:model];
    }
    [messageDict setObject:messageArr forKey:@"message"];
     [messageDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callback(messageDict);
}
//解析订单
+(void)jsonAnalysWithOrderJson:(id)json Callback:(CallBack)callback
{
    NSMutableDictionary * commentDict =[NSMutableDictionary dictionary];
    NSMutableArray * commentArray =[NSMutableArray array];
    NSArray *array =[json objectForKey:@"data"];
    for (NSDictionary * dictionary in array) {
        OrderModel * ordermodel = [OrderModel mj_objectWithKeyValues:dictionary];
        [commentArray addObject:ordermodel];
        [commentDict setObject:commentArray forKey:@"ordermodel"];
    }
    [commentDict setObject:[json objectForKey:@"paginated"] forKey:@"paginated"];
    callback(commentDict);
    
}
//解析收藏
+(void)jsonAnalysWithCollectJson:(id)json Callback:(CallBack)callback
{
    callback(nil);
}
//解析红包数据
+(void)jsonAnalysWithRedPacketJson:(id)json Callback:(CallBack)callback
{
    NSDictionary * data = [json objectForKey:@"data"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[data objectForKey:@"count"] forKey:@"count"];
    NSArray * arr = [data objectForKey:@"list"];
    NSMutableArray * list = [NSMutableArray array];
    for (NSDictionary *redDict in arr) {
        RedPacketModel * model = [RedPacketModel mj_objectWithKeyValues:redDict];
        [list addObject:model];
    }
    [dict setObject:list forKey:@"list"];
    callback(dict);
}
@end

//
//  HomeDataTool.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/8.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "HomeDataTool.h"
#import "MJExtension.h"
#import "AFNetHttp.h"
#import "Mask.h"
#import "Action.h"
#import "Slider.h"
#import "Function.h"

@implementation HomeDataTool
+(void)getsomeThing:(NSString *)url success:(CallBack)success failure:(CallBack)failure
{
    [AFNetHttp getData:url params:nil session:YES success:^(NSDictionary *response) {
        success(response);
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)getHomeDataWithUrl:(NSString *)url success:(CallBack)success failure:(CallBack)failure
{
    __WEAK_SELF_YLSLIDE
    [AFNetHttp getData:url params:nil session:NO success:^(id json) {

 
    [weakSelf jsonAnalysisWithJson:json Callback:success];
     
    } failure:^(id error) {
        failure(error);
    }];
}
+(void)jsonAnalysisWithJson:(id)json  Callback:(CallBack)callBack
{
    NSMutableDictionary * contentDict =[NSMutableDictionary dictionary];
    NSMutableArray * sliderArr =[NSMutableArray array];
    NSMutableArray * functionArr =[NSMutableArray array];
    NSMutableArray * goodArr =[NSMutableArray array];
    NSMutableArray * actionHotArr =[NSMutableArray array];
     NSMutableArray * actionComArr =[NSMutableArray array];
    
    NSDictionary * jsonDict =[json objectForKey:@"data"];
    for (id key in jsonDict) {
        if([key isEqualToString:@"slider"])
        {
            NSArray * array =[jsonDict objectForKey:key];
            for (NSDictionary * dictionary in array) {
                Slider *slider = [Slider mj_objectWithKeyValues:dictionary];
                [sliderArr addObject:slider];
            }
            [contentDict setObject:sliderArr forKey:@"slider"];
        }
        
        if([key isEqualToString:@"nav"])
        {
            NSArray * array =[jsonDict objectForKey:key];
            for (NSDictionary * dictionary in array) {
                Function *function = [Function mj_objectWithKeyValues:dictionary];
                [functionArr addObject:function];
            }
            [contentDict setObject:functionArr forKey:@"index_nav"];
        }
        if([key isEqualToString:@"promote_goods"])
        {
            NSArray * array =[jsonDict objectForKey:key];
            for (NSDictionary * dictionary in array) {
                Mask *mask = [Mask mj_objectWithKeyValues:dictionary];
                [goodArr addObject:mask];
            }
          [contentDict setObject:goodArr forKey:@"promote_goods"];
        }
        if([key isEqualToString:@"ad"])
        {
            NSArray * array =[jsonDict objectForKey:key];
            for (NSDictionary * dictionary in array)
            {
                for (id dictKey in dictionary)
                {
                    if([dictKey isEqualToString:@"index_hot"])
                    {
                        NSDictionary * valueDict =[dictionary objectForKey:dictKey];
                        Action *action = [Action mj_objectWithKeyValues:valueDict];
                        [actionHotArr addObject:action];
                        
                    }
                    if([dictKey isEqualToString:@"index_com"])
                    {
                        NSDictionary * valueDict =[dictionary objectForKey:dictKey];
                        Action *action = [Action mj_objectWithKeyValues:valueDict];
                        [actionComArr addObject:action];
                        
                    }
                }
               
            }
           [contentDict setObject:actionHotArr forKey:@"index_ad_hot"];
            [contentDict setObject:actionComArr forKey:@"index_ad_com"];
        }
        
        
        
    }
    
    callBack(contentDict);
    
}
@end

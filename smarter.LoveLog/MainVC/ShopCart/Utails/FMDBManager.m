//
//  FMDBManager.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FMDBManager.h"
#import <MJExtension.h>
@implementation FMDBManager
static FMDatabase *_fmdb;

+ (void)initialize
{
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"cart.sqlite"];
    _fmdb = [FMDatabase databaseWithPath:fileName];
    [_fmdb  open];
    
}

+ (int)selectCount
{
    int count = 0;
    if ([_fmdb open]) {
        FMResultSet * result = [_fmdb executeQuery:@"select * from cartTable;"];
        while ([result next]) {
            //有表 就返回表中的内容
            NSString * str = [result stringForColumn:@"shopModel"];
            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError * err;
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            ShoppingModel * model  = [ShoppingModel mj_objectWithKeyValues:dict];
            
            model.selectState = YES;
            count += [model.goods_number intValue];
        }
        [_fmdb close];
        
    }
    
    return count;

}
+ (NSArray *)selectCart
{
     NSMutableArray * cartArr = [NSMutableArray array];
    if ([_fmdb open]) {
        FMResultSet * result = [_fmdb executeQuery:@"select * from cartTable;"];
        while ([result next]) {
            //有表 就返回表中的内容
            NSString * str = [result stringForColumn:@"shopModel"];
            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError * err;
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            ShoppingModel * model  = [ShoppingModel mj_objectWithKeyValues:dict];
  
            model.selectState = YES;
            [cartArr addObject:model];
        }
       [_fmdb close];
        
    }
    
    return cartArr;
    
}
+ (void)addCart:(ShoppingModel *)model
{
    //对象转dict  dict 转data
  
    
    if ([_fmdb open]) {
        
        NSDictionary * dict = model.mj_keyValues;
        NSError *parseError = nil;
        
        NSData *Data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
        
        FMResultSet * result = [_fmdb executeQuery:@"select * from cartTable;"];
        if ([result next]) {
            //有表 把数据添加进去
            
             NSString * updataQuery = [NSString stringWithFormat:@"select * from cartTable  where shopID = '%@' and  shopType = '%@';",model.rec_id,model.rec_type];
             FMResultSet * result = [_fmdb executeQuery:updataQuery];
          
            if ([result next]) {
                
                //更新商品数量
                NSString * modelStr = [result stringForColumn:@"shopModel"];
                NSData * modelData = [modelStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError * modelerr;
                NSDictionary * modelDict = [NSJSONSerialization JSONObjectWithData:modelData options:NSJSONReadingMutableContainers error:&modelerr];
                ShoppingModel * resultModel  = [ShoppingModel mj_objectWithKeyValues:modelDict];
                
                int number = [model.goods_number intValue] + [resultModel.goods_number intValue];
                model.goods_number  = [NSString stringWithFormat:@"%d",number];
                [FMDBManager updataCart:model];
            }
            else
            {
                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO cartTable (shopID ,shopType, shopModel) VALUES ('%@','%@','%@');", model.rec_id,model.rec_type,str];
                BOOL xxxx =   [_fmdb executeUpdate:insertSql];
                FLog(@"insert resule = %d",xxxx);
            }

        }
        else
        {
            //没表 创建表  添加数据
            NSString * createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS cartTable(shopID  TEXT NOT NULL , shopType TEXT NOT NULL, shopModel TEXT NOT NULL);"];
            [_fmdb executeUpdate:createSQL];
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO cartTable (shopID ,shopType, shopModel) VALUES ('%@','%@','%@');", model.rec_id,model.rec_type,str];
            BOOL xx = [_fmdb executeUpdate:insertSql];
            FLog(@"insert resule = %d",xx);
            
        }
        [_fmdb close];
    }
   
    
 
}
+ (void)delectCart:(ShoppingModel *)model
{
  
    if ([_fmdb open]) {
        BOOL xx = [_fmdb executeUpdate:@"delete from cartTable where shopID = ?  and shopType = ? ",model.rec_id,model.rec_type];
        FLog(@"delete result = %d", xx);
        [_fmdb close];
    }
  
  
}
+ (void)updataCart:(ShoppingModel *)model
{
    
    if ([_fmdb open]) {
         NSDictionary * dict = model.mj_keyValues;
        NSError *parseError = nil;
        
        NSData *Data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
        BOOL xxx = [_fmdb executeUpdate:@"UPDATE cartTable SET shopModel = ?  where  shopID = ?  and shopType = ? " , str ,model.rec_id,model.rec_type] ;
        FLog(@"updata result = %d",xxx );
       [_fmdb close];
    }
  
}

+ (void)postData
{
    NSArray * arr = [FMDBManager selectCart];
    if (arr.count >0) {
        //提交数据
        for (ShoppingModel * model in arr) {
            [GoodsTool postData:@"/cart/create" params:@{@"id":model.rec_id,@"number":model.goods_number,@"spec":@""} success:^(id obj) {
                
                FLog(@"数据提交成功");
                [FMDBManager delectCart:model];
            } failure:^(id obj) {
                if ([obj isKindOfClass:[NSError class]]) {
                    NSError * er = obj;
                    if ([[er.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
                        [FMDBManager delectCart:model];
                       FLog(@"数据提交成功");
                    }
                }
                
                else
                {
                    FLog(@"%@",[obj objectForKey:@"error_desc"]);
                }
            }];
        }
        
    }
}

@end

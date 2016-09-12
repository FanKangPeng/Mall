//
//  EstimateModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstimateModel : NSObject
@property(nonatomic,copy)NSString * cmt_id;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * like_count;
@property(nonatomic,copy)NSString * cmt_rank;
@property(nonatomic,copy)NSString * parent_id;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,strong)NSDictionary * user;
@property(nonatomic,copy)NSString * floor;
@end

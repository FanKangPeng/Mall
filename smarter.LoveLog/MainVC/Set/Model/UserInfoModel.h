//
//  UserInfoModel.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/29.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

/**
 单例
 */
+(UserInfoModel*)sharedInstance;
/**
 *  用户ID
 */
@property(nonatomic,copy)NSString * id;
/**
 *  真实姓名
 */
@property(nonatomic,copy)NSString * real_name;
/**
 *  微信ID
 */
@property(nonatomic,copy)NSString * wxid;
/**
 *  性别（0/1/2）
 */
@property(nonatomic,copy)NSString * sex;
/**
 *  手机
 */
@property(nonatomic,copy)NSString * mobile;
/**
 *  网名
 */
@property(nonatomic,copy)NSString * nick_name;
/**
 *  手机
 */
@property(nonatomic,copy)NSString * sex_name;
/**
 *  性别名称(未知、男、女)
 */
@property(nonatomic,copy)NSString * rank_level;
/**
 *  等级名称
 */
@property(nonatomic,copy)NSString * rank_name;


/**
 *  头像链接
 */
@property(nonatomic,copy)NSString * avatar;
/**
 *  姓名
 */
@property(nonatomic,copy)NSString * name;
/**
 *  mobile_validated
 */
@property(nonatomic,copy)NSString * mobile_validated;
/**
 *  生日
 */
@property(nonatomic,copy)NSString * birthday;
/**
 *  email_validated
 */
@property(nonatomic,copy)NSString * email_validated;
/**
 *  signature
 */
@property(nonatomic,copy)NSString * signature;
/**
 *  no_notice
 */
@property(nonatomic,copy)NSString * no_notice;

/**
 *  邮箱
 */
@property(nonatomic,copy)NSString * email;
/**
 *  收藏数量
 */
@property(nonatomic,copy)NSString * collection_num;
/**
 *  订单数
 */

@property(nonatomic,strong)NSDictionary * order_num;

//session



@end

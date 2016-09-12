//
//  ShareManager.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject
/**
 单例
 */
+(ShareManager*)sharedInstance;
/**
 *构建一个方法
 *参数为分享用的 图片、title、连接、所在的view、
 */
-(void)createShareContentWithShareDict:(NSDictionary*)dict andShareView:(UIView *)view;
@end

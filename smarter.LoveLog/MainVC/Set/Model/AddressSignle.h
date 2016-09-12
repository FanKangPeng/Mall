//
//  AddressSignle.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/14.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressSignle : NSObject
/**
 单例
 */
+(AddressSignle*)sharedInstance;
@property(nonatomic,strong)NSMutableArray * provinceArray;
@end

//
//  Mask.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mask : NSObject
@property (nonatomic,strong)NSString * maskID;
@property (nonatomic,strong)NSString * maskName;
@property (nonatomic,strong)NSString * maskPrice;
@property (nonatomic,strong)NSString * maskImage;
@property (nonatomic,strong)NSString * maskUrl;
@property (nonatomic,strong)NSArray * maskImageArr;
@property (nonatomic,assign)NSUInteger maskCount;


@end

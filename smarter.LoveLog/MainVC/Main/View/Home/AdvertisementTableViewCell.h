//
//  AdvertisementTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Action.h"


typedef void(^AdvertisementBlock)(NSString * action,NSString * param);

@interface AdvertisementTableViewCell : UITableViewCell

@property(nonatomic,strong)NSArray * actionArray;
@property (nonatomic,copy)AdvertisementBlock advertisementBlock;
@property(nonatomic,strong)UIImageView * actionImage;
/**
 广告位block方法
 */
-(void)advertisementClick:(AdvertisementBlock)advertisementBlock;

@end

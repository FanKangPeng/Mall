//
//  OtherTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTableViewCell : UITableViewCell
@property (nonatomic ,copy) void(^otherCellBlock)();
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)dict;
@end

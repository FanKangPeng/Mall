//
//  TypeTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeTableViewCell : UITableViewCell
{
    CGFloat btnTag;
}
@property (nonatomic ,strong) UIImageView *typeIcon;
@property (nonatomic ,strong) UILabel *typeLb;

@property (nonatomic ,strong) UILabel *contentLb;
@property (nonatomic ,strong) NSDictionary *dataDict;
@property (nonatomic ,copy) void (^cellBlock)(NSInteger CellTag, NSInteger btnTag , NSString * btnTitle);
@end

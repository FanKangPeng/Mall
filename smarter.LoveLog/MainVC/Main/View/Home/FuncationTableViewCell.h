//
//  FuncationTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/8.
//  Copyright © 2016年 FanKing. All rights reserved.
//
#import "Function.h"
#import <UIKit/UIKit.h>


@interface FuncationTableViewCell : UITableViewCell
@property(nonatomic,strong)NSArray * funcationArray;
@property(nonatomic,strong)NSMutableArray * nameArr;
@property (nonatomic,copy)void(^CarouselCellBtnBlcok)(NSString * action,NSString * param);

@end

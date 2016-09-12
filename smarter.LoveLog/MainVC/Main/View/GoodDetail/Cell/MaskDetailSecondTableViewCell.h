//
//  MaskDetailSecondTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/4.
//  Copyright © 2015年 FanKing. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "GoodModel.h"
@interface MaskDetailSecondTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * listView;
@property (nonatomic,strong)NSDictionary * dict;
@property(nonatomic,copy)void(^SpecificationBlock)();
@property(nonatomic,copy)void(^NoticeBlock)();
@property (nonatomic,strong)GoodModel * goodModel;



@end

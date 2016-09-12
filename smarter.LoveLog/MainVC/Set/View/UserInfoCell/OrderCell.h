//
//  OrderCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderCell : UITableViewCell
@property(nonatomic,strong)OrderModel * orderModel;
@property(nonatomic,strong)UILabel *IDlabel;
@property(nonatomic,strong)UILabel *rightLable;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)UIView * orderContentView;
@property(nonatomic,strong)UIView * buttonView;
@property(nonatomic,copy)void(^OrderCellBlock)(NSInteger index,NSString*order_id);


@end

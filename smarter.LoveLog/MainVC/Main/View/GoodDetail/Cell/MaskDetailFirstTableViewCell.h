//
//  MaskDetailFirstTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/3.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "LineLabel.h"
@protocol MaskDetailFirstDelegate <NSObject>

-(void)toImageDetail;


@end

@interface MaskDetailFirstTableViewCell : UITableViewCell
{
    CGFloat height;
    UILabel * timerLabel;
    NSTimer * _timer;
    NSString * todate;
}

@property (nonatomic,strong)GoodModel * goodModel;
@property (nonatomic,strong)NSMutableArray * imageArr;
@property(nonatomic,assign)id<MaskDetailFirstDelegate>delegate;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)LineLabel * masketLabel;
@property (nonatomic,strong)UIView * countView;
@property (nonatomic,strong)UIButton * moreButton;
@property (nonatomic,strong)UIView * activityView;
@end

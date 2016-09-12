//
//  EstimateTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateModel.h"
@interface EstimateTableViewCell : UITableViewCell
{
    CGFloat height;
}
@property(nonatomic,strong)UIImageView *portraitImageView;

@property(nonatomic,strong)EstimateModel * model;

@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * contentLable;
@property(nonatomic,strong)UIImageView * image1;
@property(nonatomic,strong)UIImageView * image2;
@property(nonatomic,strong)UIImageView * image3;
@property(nonatomic,strong)UIImageView * image4;
@property(nonatomic,strong)UIImageView * image5;
@end

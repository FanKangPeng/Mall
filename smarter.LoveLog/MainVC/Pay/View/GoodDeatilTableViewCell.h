//
//  GoodDeatilTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingModel.h"
@interface GoodDeatilTableViewCell : UITableViewCell


@property (nonatomic,strong)ShoppingModel * shopModel;


@property (nonatomic,strong)UIImageView * goodImageView;
@property (nonatomic,strong)UIImageView * moreImageView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * countLabel;
@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UILabel * priceLabel;


@end

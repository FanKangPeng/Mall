//
//  AddressTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddressTableViewCell : UITableViewCell

@property(nonatomic,strong)AddressModel * addressModel;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * numLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)UILabel * defaultLabel;
@property(nonatomic,strong)UIButton * defaultButton;
@property(nonatomic,strong)UIView * view1;


@property (nonatomic ,strong) UIImageView * selectImg;

@property (nonatomic ,assign) BOOL showSelectImg;


@property(nonatomic,copy) void(^addressCellBlockDefault)(NSString *  index);


@property(nonatomic,copy) void(^addressCellBlockEdit)(NSString*  index);


@property(nonatomic,copy) void(^addressCellBlockDelete)(NSString * index);

@end

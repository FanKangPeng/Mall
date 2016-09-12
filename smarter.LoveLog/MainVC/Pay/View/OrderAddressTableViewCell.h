//
//  OrderAddressTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface OrderAddressTableViewCell : UITableViewCell
@property(nonatomic,strong)AddressModel * addressModel;
@property (nonatomic ,strong) UIView *adressView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * iphoneLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property (nonatomic ,strong) UILabel *typeLabel;
@property (nonatomic ,strong) UILabel *noAddressLb;
@end

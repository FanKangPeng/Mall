//
//  DistributionTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * expressTypeLb;
@property(nonatomic,strong)UILabel * payTypeLb;
@property (nonatomic ,strong) UILabel *descriptionLb;
@property (nonatomic ,strong) NSDictionary *dict;
@end

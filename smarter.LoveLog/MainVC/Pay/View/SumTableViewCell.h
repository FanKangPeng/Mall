//
//  SumTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SumTableViewCell : UITableViewCell
@property (nonatomic,strong)NSArray * sumArr;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * payTypeLabel;
@property(nonatomic,strong)UILabel * distributionLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@end

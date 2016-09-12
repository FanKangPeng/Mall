//
//  MaskDetailThreeTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/4.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mask.h"
@interface MaskDetailThreeTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)Mask * mask;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMask:(Mask*)mask;


@end

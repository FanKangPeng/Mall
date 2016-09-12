//
//  CarouselTableViewCell.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Slider.h"



@interface CarouselTableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray * sliderArr;
@property (nonatomic ,strong)UIView * midView;
@property (nonatomic,copy)void(^CarouselCellBlock)(NSString * action,NSString * param);








@end

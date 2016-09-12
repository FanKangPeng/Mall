//
//  ClassifyTableViewCell.h
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//



#import <UIKit/UIKit.h>





@interface ClassifyTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * imageView1;
@property(nonatomic,strong)UIImageView * imageView2;


@property(nonatomic,copy)void(^ClassifyTableViewCellOneBlock)(NSString * action,NSString * param);
@property(nonatomic,copy)void(^ClassifyTableViewCellTwoBlock)(NSString * action,NSString * param);

@property (nonatomic,strong)NSArray * actionArray;




@end

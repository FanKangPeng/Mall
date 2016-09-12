//
//  MyCommentCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"
#import <MLLabel/MLLabel.h>
#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>

#import <MLTextAttachment.h>
@interface MyCommentCell : UITableViewCell
@property(nonatomic,strong)MyCommentModel * commentModel;

@property (nonatomic,strong) UIImageView*portraitImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) MLLabel * concentLabel;
@property (nonatomic,strong) UILabel * objectLabel;
@property (nonatomic,copy)void(^MyCommentCellBlock)(MyCommentModel * commentModel);

@property (nonatomic ,strong)  MLExpression *exp;

@end

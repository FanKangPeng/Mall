//
//  MessageTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MessageCellDelegate;
@interface MessageTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic ,copy) void (^messageBlock)(NSString *textField_text);
@end

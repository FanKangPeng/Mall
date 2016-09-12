//
//  ChatViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/15.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ChatViewController : RCConversationViewController<UIActionSheetDelegate,RCMessageCellDelegate>
/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;
@end

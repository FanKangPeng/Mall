//
//  NotReachView.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/24.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotReachView : UIView
+ (NotReachView*)shareInstance;
@property(nonatomic,assign)id  error;
@property(nonatomic,copy)void(^ReloadButtonBlock)();
@end

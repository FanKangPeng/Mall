//
//  ThirdPartyLoginView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/14.
//  Copyright © 2015年 FanKing. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface ThirdPartyLoginView : UIView

-(instancetype)initViewWithFrame:(CGRect)Frame;
@property(nonatomic ,copy)void(^ThirdPartyLoginViewBlock)(NSDictionary * data);
@property(nonatomic ,copy)void(^ThirdPartyLoginViewWeChatBlock)();
@property(nonatomic ,copy)void(^ThirdPartyLoginViewSinaBlock)();

@end

//
//  Award.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"
@interface Award : NSObject<QuadCurveMenuItemDelegate,UIGestureRecognizerDelegate>
{
    BOOL  isOpen;
    NSMutableArray * menus;
    UIView * mengceng;
    UIView * toumingView;
}
/**打赏block*/
@property (nonatomic,copy)void(^AwardBlock)(NSString * rewardCount);

@property (nonatomic ,strong) QuadCurveMenuItem * item;
/**打赏动画结束后block*/
@property (nonatomic,copy)void(^AwardAnimateBlock)();
/**
 单例
 */
+(Award*)sharedInstance;
/**打赏按钮点击*/
-(void)awardViewTapClick:(UIButton*)tap witheven:(UIEvent*)even;
/**成功打赏*/
-(void)awardSuccess;
/**打赏失败*/
-(void)awardFailer;
@end

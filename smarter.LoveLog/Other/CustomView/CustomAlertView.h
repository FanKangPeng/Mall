//
//  CustomAlertView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//




#import <UIKit/UIKit.h>


@protocol CustomAlertViewDelegate;

@interface CustomAlertView : UIView
{
    NSString * titleStr;
    NSString * messageStr;
    NSString * cancelButtonTitleStr;
    NSString * otherButtonTitleStr;
    CGFloat viewHeight;
    UIView * toumingView;
}
@property(nonatomic,weak)id<CustomAlertViewDelegate>delegate;


@property(nonatomic,strong)UILabel * TitleLabel;
@property(nonatomic,strong)UILabel * ContentLabel;
@property(nonatomic,strong)UIButton * CancelButton;
@property(nonatomic,strong)UIButton * ConfirmButton;


/**
 *初始化CustomAlertView
 * 参数 title message delegate cancelButtonTitle otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
/**
 *显示
 */
-(void)show;
/**
 *隐藏
 */
-(void)hide;
@end

@protocol CustomAlertViewDelegate <NSObject>

-(void)customAlertView:(CustomAlertView*)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
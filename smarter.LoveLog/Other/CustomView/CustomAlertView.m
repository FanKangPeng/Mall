//
//  CustomAlertView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CustomAlertView.h"
#define BACKVIEWWIDTH kScreenWidth-kScreenWidth/4
#define BUTTONWIDTH (kScreenWidth-kScreenWidth/4-45)/2
#define Color_self [UIColor colorWithRed:229.00/255.00 green:229.00/255.00 blue:229.00/255.00 alpha:1]
@implementation CustomAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    
    self =[super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    titleStr = title;
    messageStr = message;
    cancelButtonTitleStr = cancelButtonTitle;
    otherButtonTitleStr = otherButtonTitles;

    viewHeight+=30;
    
    [self setBackgroundColor:[UIColor blackColor]];
    self.alpha = 0.3;
    
    toumingView =[[UIView alloc] initWithFrame:self.frame];
    [toumingView setBackgroundColor:[UIColor clearColor]];
  
    
    
    
    UIView * backView =[[UIView alloc] init];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [toumingView addSubview:backView];
    backView.layer.cornerRadius=10;
    backView.layer.masksToBounds =YES;
    if(title.length>0)
    {
        [backView addSubview:self.TitleLabel];
        
    }
   
    if(messageStr.length>0)
    {
         [backView addSubview:self.ContentLabel];
    }
    if(cancelButtonTitleStr.length>0 ||otherButtonTitleStr.length >0)
    {
        viewHeight +=(BACKVIEWWIDTH-45)/6;
        viewHeight +=55;
        UILabel * line =[[UILabel alloc] initWithFrame:CGRectMake(15, viewHeight-30-BUTTONWIDTH/3,BACKVIEWWIDTH-30 , SINGLE_LINE_WIDTH/2)];
        [line setBackgroundColor:Color_self];
        [backView addSubview:line];
    }
    if(cancelButtonTitleStr.length>0)
    {
        [backView addSubview:self.CancelButton];
        
    }
    
    if(otherButtonTitleStr.length>0)
    {
         [backView addSubview:self.ConfirmButton];
    }
    
    
   
    
    backView.frame =CGRectMake(kScreenWidth/8, kScreenHeight/2-viewHeight/2, BACKVIEWWIDTH, viewHeight);
    return self;
}
-(UILabel *)TitleLabel
{
    if(!_TitleLabel)
    {
        _TitleLabel =[[UILabel alloc] initWithFrame:self.bounds];
        _TitleLabel.font = DefaultFontSize(16);
   
        _TitleLabel.text = titleStr;
        _TitleLabel.textColor =FontColor_black;
        _TitleLabel.numberOfLines =0;
        _TitleLabel.textAlignment=NSTextAlignmentLeft;
        CGSize size = [_TitleLabel sizeThatFits:CGSizeMake(BACKVIEWWIDTH-40, MAXFLOAT)];
        _TitleLabel.frame = CGRectMake(20, viewHeight, BACKVIEWWIDTH-40, size.height);
        if( size.height>30)
        {
            _TitleLabel.textAlignment=NSTextAlignmentLeft;
        }
        else
            _TitleLabel.textAlignment=NSTextAlignmentCenter;
        viewHeight +=_TitleLabel.frame.size.height;
    }
    return _TitleLabel;
}
-(UILabel *)ContentLabel
{
    if(!_ContentLabel)
    {
        if(self.TitleLabel)
        {
            viewHeight +=10;
        }
        _ContentLabel =[[UILabel alloc] initWithFrame:self.bounds];
        _ContentLabel.font = DefaultFontSize(14);
        _ContentLabel.text = messageStr;
        _ContentLabel.textColor =FontColor_gary;
        _ContentLabel.numberOfLines =0;
        _ContentLabel.textAlignment=NSTextAlignmentLeft;
        CGSize size = [_ContentLabel sizeThatFits:CGSizeMake(BACKVIEWWIDTH-40, MAXFLOAT)];
        _ContentLabel.frame = CGRectMake(20, viewHeight, BACKVIEWWIDTH-40, size.height);
        if( size.height>30)
        {
            _ContentLabel.textAlignment=NSTextAlignmentLeft;
        }
        else
            _ContentLabel.textAlignment=NSTextAlignmentCenter;
        
        viewHeight += _ContentLabel.frame.size.height;
    }
    return _ContentLabel;
}
-(UIButton *)CancelButton
{
    if(!_CancelButton)
    {
       
        _CancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        if(otherButtonTitleStr.length>0)
            _CancelButton.frame = CGRectMake(15, viewHeight-BUTTONWIDTH/3-15, (BACKVIEWWIDTH-45)/2,BUTTONWIDTH/3);
        else
            _CancelButton.frame = CGRectMake(15, viewHeight-BUTTONWIDTH/3-15,BACKVIEWWIDTH-30,BUTTONWIDTH/3);
        _CancelButton.layer.cornerRadius =4;
        _CancelButton.layer.masksToBounds =YES;
        _CancelButton.layer.borderColor=Color_self.CGColor;
        _CancelButton.layer.borderWidth = SINGLE_LINE_WIDTH;
        _CancelButton.titleLabel.font =DefaultFontSize(14);
        [_CancelButton setTitle:cancelButtonTitleStr forState:UIControlStateNormal];
        [_CancelButton setTitleColor:FontColor_black forState:UIControlStateNormal];
        [_CancelButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:self.bounds.size] forState:UIControlStateNormal];
        [_CancelButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.00/255.00 green:180.00/255.00 blue:180.00/255.00 alpha:1] size:self.bounds.size] forState:UIControlStateHighlighted];
        [_CancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _CancelButton;
}
-(UIButton *)ConfirmButton
{
    if(!_ConfirmButton)
    {
        
        _ConfirmButton =[UIButton buttonWithType:UIButtonTypeCustom];
        if(cancelButtonTitleStr.length>0)
            _ConfirmButton.frame = CGRectMake(BACKVIEWWIDTH-15-BUTTONWIDTH, viewHeight-BUTTONWIDTH/3-15, BUTTONWIDTH, BUTTONWIDTH/3);
        else
              _ConfirmButton.frame = CGRectMake(15, viewHeight-BUTTONWIDTH/3-15,BACKVIEWWIDTH-30,BUTTONWIDTH/3);
//           _ConfirmButton.frame = CGRectMake( (kScreenWidth-kScreenWidth/4)/2-(kScreenWidth-kScreenWidth/4-45)/4, viewHeight-BUTTONWIDTH/3-15,BUTTONWIDTH,BUTTONWIDTH/3);
        
        NSLog(@"%f", (kScreenWidth-kScreenWidth/4)/2-(kScreenWidth-kScreenWidth/4-45)/4);
        _ConfirmButton.layer.cornerRadius =4;
        _ConfirmButton.layer.masksToBounds =YES;
        _ConfirmButton.titleLabel.font =DefaultFontSize(14);
        [_ConfirmButton setTitle:otherButtonTitleStr forState:UIControlStateNormal];
        [_ConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ConfirmButton setBackgroundImage:[self imageWithColor:NavigationBackgroundColor size:self.bounds.size] forState:UIControlStateNormal];
        [_ConfirmButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:252.00/255.00 green:19.00/255.00 blue:89.00/255.00 alpha:.5] size:self.bounds.size] forState:UIControlStateHighlighted];
        [_ConfirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchDown];

    }
    return _ConfirmButton;
}
-(void)cancelButtonClick:(UIButton*)button
{
     [self hide];
    [self.delegate customAlertView:self clickedButtonAtIndex:0];
}
-(void)confirmButtonClick:(UIButton*)button
{
   [self hide];
    [self.delegate customAlertView:self clickedButtonAtIndex:1];
}
-(void)show
{
    UIWindow * window =[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window addSubview:toumingView];
}
-(void)hide
{
    [self removeFromSuperview];
    [toumingView removeFromSuperview];
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

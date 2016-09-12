//
//  RegisterViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/7.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface RegisterViewController : SecondBaseViewController<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField * iPhoneTextField;
@property (nonatomic ,strong) UITextField * authCodeTextField;


@property (nonatomic ,strong) UIButton * authCodeBtn;
@property (nonatomic ,strong) UIButton * registerBtn;

@property (nonatomic,copy) NSString * authCode;

@property (nonatomic,copy) NSString * titleString;

@property(nonatomic,assign)NSUInteger timeCount;
@property(nonatomic,strong)NSTimer * timer;
@end

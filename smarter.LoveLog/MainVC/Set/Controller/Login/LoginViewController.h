//
//  LoginViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/7.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "CustomNavigationView.h"
#import "UserInfoModel.h"
@interface LoginViewController : SecondBaseViewController<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField * passWordTextField;
@property (nonatomic ,strong) UITextField * userNameTextField;
@property (nonatomic ,strong) UIButton * loginBtn;
@property(nonatomic,strong)UserInfoModel * userInfoModel;

@end

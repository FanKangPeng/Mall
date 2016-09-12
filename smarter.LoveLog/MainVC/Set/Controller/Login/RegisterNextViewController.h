//
//  RegisterNextViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface RegisterNextViewController : SecondBaseViewController<UITextFieldDelegate>
@property(nonatomic,copy)NSString * iphoneNumber;
@property(nonatomic,copy)NSString * authCode;
@property (nonatomic ,strong) UITextField * passWordTextField;
@property (nonatomic ,strong) UITextField * passWordSureTextField;
@property (nonatomic ,strong) UITextField * inviteCodeextField;
@property (nonatomic ,strong) UIButton * registerBtn;
@property(nonatomic,copy) NSString * titleString;
@end

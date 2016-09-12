//
//  RegisterNextViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "RegisterNextViewController.h"
#import "LoginViewController.h"
#import "ThirdPartyLoginView.h"
#import "UserInfoTool.h"
#import "RCDLoginInfo.h"
@interface RegisterNextViewController ()

@end

@implementation RegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * RegisterNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [RegisterNavigationView initViewWithTitle:self.titleString andBack:@"icon_back.png" andRightName:@"登录"];
    __WEAK_SELF_YLSLIDE
    RegisterNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    RegisterNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //登录
        [weakSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:RegisterNavigationView];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    if([self.titleString isEqualToString:@"注册"])
        [self initRegisterView];
    
    else
        [self initForgetView];
    // Do any additional setup after loading the view.
}
-(void)dissMissKeyBoard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
-(UITextField *)passWordSureTextField
{
    if (!_passWordSureTextField) {
        _passWordSureTextField =[[UITextField alloc] init];
        _passWordSureTextField.placeholder =@"请确认密码";
        _passWordSureTextField.secureTextEntry = YES;
        _passWordSureTextField.delegate =self;
        _passWordSureTextField.tag =201;
         [_passWordSureTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
        _passWordSureTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
        _passWordSureTextField.textAlignment = NSTextAlignmentLeft;
        _passWordSureTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passWordSureTextField;
}
-(UITextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField =[[UITextField alloc] init];
        _passWordTextField.placeholder =@"请输入密码";
        _passWordTextField.delegate =self;
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.tag =200;
         [_passWordTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
        _passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passWordTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
        _passWordTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _passWordTextField;
}
-(UITextField *)inviteCodeextField
{
    if (!_inviteCodeextField) {
        _inviteCodeextField =[[UITextField alloc] init];
        _inviteCodeextField.placeholder =@"请输入邀请码（选填）";
        _inviteCodeextField.delegate =self;
        _inviteCodeextField.tag =202;
         [_inviteCodeextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
        _inviteCodeextField.keyboardType =UIKeyboardTypeASCIICapable;
        _inviteCodeextField.clearButtonMode =UITextFieldViewModeWhileEditing;
        _inviteCodeextField.textAlignment = NSTextAlignmentLeft;
    }
    return _inviteCodeextField;
}
-(UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setFrame:CGRectMake(20, 0, kScreenWidth-40, 44)];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"login_register_Button"] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"login_register_Button_selected"] forState:UIControlStateSelected];
        [_registerBtn addTarget:self action:@selector(registerVoid) forControlEvents:UIControlEventTouchDown];
        _registerBtn.userInteractionEnabled = NO;
    }
    return _registerBtn;
}
-(void)initForgetView
{
    UIView * backView2 =[[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
    [backView2 setBackgroundColor:[UIColor whiteColor]];
    backView2.layer.cornerRadius=5;
    backView2.layer.masksToBounds =YES;
    [self.view addSubview:backView2];
    backView2.sd_layout
    .leftSpaceToView(self.view,kWidth(20))
    .rightSpaceToView(self.view,kWidth(20))
    .topSpaceToView(self.view,kWidth(94))
    .heightIs(kWidth(50));
    
    UIImageView * pinimage  =[[UIImageView alloc] initWithFrame:CGRectMake(15, backView2.frame.size.height/2-10, 17, 20)];
    pinimage.image =[UIImage imageNamed:@"login_icon_lock"];
    [backView2 addSubview:pinimage];
    pinimage.sd_layout
    .leftSpaceToView(backView2,KLeft)
    .topSpaceToView(backView2,kWidth(15))
    .widthIs(kWidth(14.5))
    .heightIs(kWidth(20));
    
    
    [backView2 addSubview:self.inviteCodeextField];
    _inviteCodeextField.placeholder=@"请输入您的密码";
    _inviteCodeextField.secureTextEntry = YES;
    _inviteCodeextField.sd_layout
    .leftSpaceToView(pinimage,kWidth(10))
    .topSpaceToView(backView2,0)
    .rightSpaceToView(backView2,0)
    .bottomSpaceToView(backView2,0);
    
     [_inviteCodeextField addTarget:self action:@selector(inviteCodeextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //注册按钮
    
    [self.view addSubview:self.registerBtn];
    _registerBtn.sd_layout
    .leftEqualToView(backView2)
    .rightEqualToView(backView2)
    .topSpaceToView(backView2,20)
    .heightIs(44);
    
    ThirdPartyLoginView * thirdView =[[ThirdPartyLoginView alloc] initViewWithFrame:CGRectMake(0, kScreenHeight-150, kScreenWidth, 150)];
   
    thirdView.ThirdPartyLoginViewBlock=^(NSDictionary *data){
        //
    };
    thirdView.ThirdPartyLoginViewSinaBlock=^{
        //
    };
    thirdView.ThirdPartyLoginViewWeChatBlock=^{
        //
    };
    [self.view addSubview:thirdView];
}

-(void)initRegisterView
{
    
    UIView * backView  =[[UIView alloc] init];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.cornerRadius=5;
    backView.layer.masksToBounds =YES;
    [self.view addSubview:backView];
    backView.sd_layout
    .leftSpaceToView(self.view,kWidth(20))
    .rightSpaceToView(self.view,kWidth(20))
    .topSpaceToView(self.view,kWidth(94))
    .heightIs(kWidth(100));
    
    
    UIImageView * iphoneimage  =[[UIImageView alloc] initWithFrame:CGRectMake(17, backView.frame.size.height/6-10,11.5,20)];
    iphoneimage.image =[UIImage imageNamed:@"login_icon_lock"];
    [backView addSubview:iphoneimage];
    iphoneimage.sd_layout
    .leftSpaceToView(backView,KLeft)
    .topSpaceToView(backView,kWidth(15))
    .widthIs(kWidth(14.5))
    .heightIs(kWidth(20));
    
   
    [backView addSubview:self.passWordTextField];
    _passWordTextField.sd_layout
    .leftSpaceToView(iphoneimage,kWidth(10))
    .rightSpaceToView(backView,kWidth(50))
    .topSpaceToView(backView,0)
    .heightIs(backView.height/2);
    
    
    UIView * seeView =[[UIView alloc] initWithFrame:CGRectMake(backView.frame.size.width-50, backView.frame.size.height-50, 50, 50)];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seePassWord:)];
    [seeView addGestureRecognizer:tap];
    [backView addSubview:seeView];
    seeView.sd_layout
    .topSpaceToView(backView,0)
    .rightSpaceToView(backView,0)
    .widthIs(kWidth(50))
    .heightIs(kWidth(50));
    UIImageView * seeImage  =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_eye"]];
    seeImage.frame =CGRectMake(seeView.frame.size.width/2-10, seeView.frame.size.height/2-9, 22, 14);
    [seeView addSubview:seeImage];
    

    
    UILabel * midline1  =[[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.size.height/3-SINGLE_LINE_WIDTH, backView.frame.size.width, SINGLE_LINE_WIDTH)];
    [midline1 setBackgroundColor:BackgroundColor];
    [backView addSubview:midline1];
    midline1.sd_layout
    .leftSpaceToView(backView,0)
    .rightSpaceToView(backView,0)
    .topSpaceToView(_passWordTextField,0)
    .heightIs(SINGLE_LINE_WIDTH);
    
    
    UIImageView * emailimage =[[UIImageView alloc] initWithFrame:CGRectMake(15,backView.frame.size.height/2-6,15.6, 12)];
    emailimage.image =[UIImage imageNamed:@"login_icon_lock"];
    [backView addSubview:emailimage];
    emailimage.sd_layout
    .leftSpaceToView(backView,KLeft)
    .topSpaceToView(midline1,kWidth(15))
    .widthIs(kWidth(14.5))
    .heightIs(kWidth(20));
    
    
   
    [backView addSubview:self.passWordSureTextField];
    _passWordSureTextField.sd_layout
    .leftSpaceToView(emailimage,kWidth(10))
    .rightSpaceToView(backView,kWidth(50))
    .topSpaceToView(midline1,0)
    .heightIs(backView.height/2);
    
    
    UIView * seeView1 =[[UIView alloc] initWithFrame:CGRectMake(backView.frame.size.width-50, backView.frame.size.height-50, 50, 50)];
    UITapGestureRecognizer * tap1  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seePassWord1:)];
    [seeView1 addGestureRecognizer:tap1];
    [backView addSubview:seeView1];
    seeView1.sd_layout
    .topSpaceToView(midline1,0)
    .rightSpaceToView(backView,0)
    .widthIs(kWidth(50))
    .heightIs(kWidth(50));
    UIImageView * seeImage1  =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_eye"]];
    seeImage1.frame =CGRectMake(seeView1.frame.size.width/2-10, seeView1.frame.size.height/2-9, 22, 14);
    [seeView1 addSubview:seeImage1];
    
    [_passWordSureTextField addTarget:self action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    UIView * backView2 =[[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
    [backView2 setBackgroundColor:[UIColor whiteColor]];
    backView2.layer.cornerRadius=5;
    backView2.layer.masksToBounds =YES;
    [self.view addSubview:backView2];
    backView2.sd_layout
    .topSpaceToView(backView,10)
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .heightIs(kWidth(50));
    
    UIImageView * pinimage  =[[UIImageView alloc] initWithFrame:CGRectMake(15, backView2.frame.size.height/2-10, 17, 20)];
    pinimage.image =[UIImage imageNamed:@"login_icon_pin"];
    [backView2 addSubview:pinimage];
    
  
    [backView2 addSubview:self.inviteCodeextField];
    _inviteCodeextField.sd_layout
    .leftSpaceToView(pinimage,kWidth(10))
    .topSpaceToView(backView2,0)
    .rightSpaceToView(backView2,0)
    .bottomSpaceToView(backView2,0);

    
    
    //注册按钮
   
    [self.view addSubview:self.registerBtn];
    _registerBtn.sd_layout
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .topSpaceToView(backView2,20)
    .heightIs(44);
    
    ThirdPartyLoginView * thirdView =[[ThirdPartyLoginView alloc] initViewWithFrame:CGRectMake(0, kScreenHeight-150, kScreenWidth, 150)];
    thirdView.ThirdPartyLoginViewBlock=^(NSDictionary * data){
        //
    };
    thirdView.ThirdPartyLoginViewSinaBlock=^{
        //
    };
    thirdView.ThirdPartyLoginViewWeChatBlock=^{
        //
    };
    [self.view addSubview:thirdView];
    
}
-(void)seePassWord:(UITapGestureRecognizer*)tap
{
    
    if(_passWordTextField.secureTextEntry)
    {
        _passWordTextField.secureTextEntry = NO;
    }
    else
    {
        _passWordTextField.secureTextEntry =YES;
    }
    
}
-(void)seePassWord1:(UITapGestureRecognizer*)tap
{
    
    if(_passWordSureTextField.secureTextEntry)
    {
        _passWordSureTextField.secureTextEntry = NO;
    }
    else
    {
        _passWordSureTextField.secureTextEntry =YES;
    }
    
}
/*
 *注册
 */
-(void)registerVoid
{
    if ([self.titleString isEqualToString:@"注册"]) {
        if ([_passWordSureTextField.text isEqualToString:_passWordTextField.text]) {
            
            [self registerzhanghao];
        }
        else
        {
            HUDVIEW(@"两次输入的密码不一致", self.view);
            _passWordSureTextField.text=@"";
        }
    }
    else
    {
        __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.color  =[UIColor clearColor];
        hud.mode= MBProgressHUDModeCustomView;
        hud.customView = [[LoadGIF_M alloc] init];
        [hud show:YES];
        [UserInfoTool userInfo:@"/user/reset_pwd" params:@{@"mobile":self.iphoneNumber,@"vcode":self.authCode,@"password":_inviteCodeextField.text} success:^(id obj) {
            [hud hide:YES];
            HUDVIEW(@"密码设置成功", self.view);
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
           
        } failure:^(id obj) {
            [hud hide:YES];
            if (obj) {
                HUDVIEW([obj objectForKey:@"error_desc"], self.view);
            }
            else
            {
                HUDVIEW(@"找回密码失败", self.view);
            }
        }];
    }
    
}
//注册
-(void)registerzhanghao
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView =[[LoadGIF_M alloc] init];
    [hud show:YES];

       [UserInfoTool userInfo:@"/user/signup" params:@{@"mobile":self.iphoneNumber,@"vcode":self.authCode,@"password":_passWordSureTextField.text,@"invite_code":_inviteCodeextField.text} success:^(id obj) {
          [hud hide:YES];
           //注册融云
           [[RCDLoginInfo shareLoginInfo] ChatRegisterWithDict:@{@"password":_passWordSureTextField.text,@"username":self.iphoneNumber}];
           HUDVIEW(@"注册成功", self.view);
           double delayInSeconds = 1.0;
           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
           dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
           });
           
       } failure:^(id obj) {
             [hud hide:YES];
           if (obj) {
               HUDVIEW([obj objectForKey:@"error_desc"], self.view);
           }
           else
           {
               HUDVIEW(@"注册失败", self.view);
           }
       }];


}
-(void)passwordTextFieldChange:(UITextField*)textfield
{
    if (textfield.text.length==_passWordTextField.text.length) {
        _registerBtn.selected = YES;
        _registerBtn.userInteractionEnabled = YES;
    }
    else
    {
        _registerBtn.selected = YES;
        _registerBtn.userInteractionEnabled = YES;
    }
}
-(void)inviteCodeextFieldChange:(UITextField*)textField
{
    if (textField.text.length>=6 && textField.text.length<=14) {
        _registerBtn.selected = YES;
        _registerBtn.userInteractionEnabled = YES;
    }
    else
    {
        _registerBtn.selected = YES;
        _registerBtn.userInteractionEnabled = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==200) {
        if (!IS_A_PASSWORLD(textField.text)) {
            HUDVIEW(@"密码格式错误(6-14位的数字或字母组合)", self.view);
            _passWordTextField.text =@"";
            [_passWordTextField becomeFirstResponder];
        }
   
    }
    
    if([self.titleString isEqualToString:@"找回密码"])
    {
        if (!IS_A_PASSWORLD(textField.text)) {
            HUDVIEW(@"密码格式错误(6-14位的数字或字母组合)", self.view);
            _inviteCodeextField.text =@"";
            [_inviteCodeextField becomeFirstResponder];
        }
    }
    
}
-(void)back
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

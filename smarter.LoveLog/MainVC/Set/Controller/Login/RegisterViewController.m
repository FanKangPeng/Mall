//
//  RegisterViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/7.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomNavigationView.h"
#import "ThirdPartyLoginView.h"
#import "UserInfoTool.h"
#import "RegisterNextViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize iPhoneTextField,authCodeTextField,authCodeBtn,registerBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * RegisterNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [RegisterNavigationView initViewWithTitle:self.titleString andBack:@"icon_back.png" andRightName:@"登录"];
    RegisterNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [self back];
    };
    RegisterNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //登录
        [self back];
    };
    [self.view addSubview:RegisterNavigationView];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    [self initRegisterView];
    // Do any additional setup after loading the view.
}
-(void)dissMissKeyBoard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
-(void)initRegisterView
{
    CGFloat  height =94;
    
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
    iphoneimage.image =[UIImage imageNamed:@"register_icon_phone"];
    [backView addSubview:iphoneimage];
    iphoneimage.sd_layout
    .leftSpaceToView(backView,kWidth(KLeft+2))
    .topSpaceToView(backView,kWidth(15))
    .widthIs(kWidth(11.5))
    .heightIs(kWidth(20));
    
    iPhoneTextField =[[UITextField alloc] initWithFrame:CGRectMake(45,0,backView.frame.size.width-50,backView.frame.size.height/3-SINGLE_LINE_WIDTH)];
    iPhoneTextField.placeholder =@"请输入您的手机号";
    iPhoneTextField.delegate =self;
    iPhoneTextField.tag =200;
     [iPhoneTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    iPhoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    iPhoneTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    iPhoneTextField.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:iPhoneTextField];
    iPhoneTextField.sd_layout
    .leftSpaceToView(iphoneimage,kWidth(10))
    .rightSpaceToView(backView,0)
    .topSpaceToView(backView,0)
    .heightIs(backView.height/2);
    
    UILabel * midline1  =[[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.size.height/3-SINGLE_LINE_WIDTH, backView.frame.size.width, SINGLE_LINE_WIDTH)];
    [midline1 setBackgroundColor:BackgroundColor];
    [backView addSubview:midline1];
    midline1.sd_layout
    .leftSpaceToView(backView,0)
    .rightSpaceToView(backView,0)
    .topSpaceToView(iPhoneTextField,0)
    .heightIs(SINGLE_LINE_WIDTH);
    
    
    UIImageView * emailimage =[[UIImageView alloc] initWithFrame:CGRectMake(15,backView.frame.size.height/2-6,15.6, 12)];
    emailimage.image =[UIImage imageNamed:@"register_icon_email"];
    [backView addSubview:emailimage];
    emailimage.sd_layout
    .leftSpaceToView(backView,kWidth(KLeft))
    .topSpaceToView(midline1,kWidth(19))
    .widthIs(kWidth(15.6))
    .heightIs(kWidth(12));
    
    
    //验证码button
    authCodeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [authCodeBtn setFrame:CGRectMake(backView.frame.size.width -105, backView.frame.size.height/2-20, 95, 40)];
    [authCodeBtn setBackgroundColor:NavigationBackgroundColor];
    [authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeBtn.titleLabel setFont:DefaultFontSize(15)];
    authCodeBtn.titleLabel .textAlignment =NSTextAlignmentCenter;
    authCodeBtn.layer.cornerRadius =5 ;
    authCodeBtn.layer.masksToBounds = NO;
    [authCodeBtn addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchDown];
    [backView addSubview:authCodeBtn];
    authCodeBtn.sd_layout
    .rightSpaceToView(backView,kWidth(10))
    .topSpaceToView(midline1,kWidth(10))
    .widthIs(90)
    .heightIs(kWidth(30));
    
    authCodeTextField =[[UITextField alloc] initWithFrame:CGRectMake(45,backView.frame.size.height/3 ,backView.frame.size.width-100, backView.frame.size.height/3-SINGLE_LINE_WIDTH)];
    authCodeTextField.placeholder =@"请输入收到的验证码";
    authCodeTextField.secureTextEntry = YES;
    authCodeTextField.delegate =self;
    authCodeTextField.tag =201;
     [authCodeTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    authCodeTextField.keyboardType =UIKeyboardTypeASCIICapable;
    authCodeTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    authCodeTextField.textAlignment = NSTextAlignmentLeft;
    authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:authCodeTextField];
    authCodeTextField.sd_layout
    .leftSpaceToView(emailimage,kWidth(10))
    .rightSpaceToView(authCodeBtn,0)
    .topSpaceToView(midline1,0)
    .heightIs(backView.height/2);
    
    [authCodeTextField addTarget:self action:@selector(authCodeTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
   

    
    //注册按钮
    registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(20, height, kScreenWidth-40, 44)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"login_next"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"login_next_selected"] forState:UIControlStateSelected];
 
    [registerBtn addTarget:self action:@selector(registerVoid) forControlEvents:UIControlEventTouchDown];
    registerBtn.userInteractionEnabled = NO;
    [self.view addSubview:registerBtn];
    registerBtn.sd_layout
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .topSpaceToView(backView,40)
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

/**
 password监控事件
 */
-(void)authCodeTextFieldChange:(UITextField*)textField
{
    if(textField.text.length==6)
    {
        registerBtn.selected =YES;
        registerBtn.userInteractionEnabled = YES;
    }
    else
    {
        registerBtn.selected=NO;
        
        registerBtn.userInteractionEnabled = NO;
    }
}
/*
 *获取验证码
 */
-(void)getAuthCode:(UIButton*)button
{
   if(iPhoneTextField.text.length==0)
   {
       HUDVIEW(@"请输入手机号", self.view);
   }
   else
   {
       if(IS_USERNAME(iPhoneTextField.text))
       {
           [iPhoneTextField resignFirstResponder];
           [self getAuthCode];
       }
       else
       {
            HUDVIEW(@"请输入正确的手机号", self.view);
       
       }
    
   }
}
-(void)getAuthCode
{
    
    
    if([self.titleString isEqualToString:@"注册"])
    {
        [UserInfoTool userInfo:@"/sms" params:@{@"type":@"signup",@"mobile":iPhoneTextField.text} success:^(id obj) {
            self.authCode = [obj objectForKey:@"vcode"];
            NSLog(@"%@",self.authCode);
            [self changeAuthCodeButton];
        } failure:^(id obj) {
            if (obj) {
                HUDVIEW([obj objectForKey:@"error_desc"], self.view);
                
            }
            else
            {
                HUDVIEW(@"获取失败", self.view);
            }
        }];
    }
    else
    {
        [UserInfoTool userInfo:@"/sms" params:@{@"type":@"reset_pwd",@"mobile":iPhoneTextField.text} success:^(id obj) {
            self.authCode = [obj objectForKey:@"vcode"];
            NSLog(@"%@",self.authCode);
            [self changeAuthCodeButton];
        } failure:^(id obj) {
            if (obj) {
                HUDVIEW([obj objectForKey:@"error_desc"], self.view);
                
            }
            else
            {
                HUDVIEW(@"获取失败", self.view);
            }
        }];

    }
}
//获取验证码成功之后 改变按钮的颜色以及内容 计时器
-(void)changeAuthCodeButton
{
    authCodeBtn.userInteractionEnabled = NO;
    authCodeBtn.backgroundColor = RGBACOLOR(51, 51, 51, 0.3);
    authCodeBtn.titleLabel.font = DefaultFontSize(12);
    _timeCount = 60;
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    [_timer fire];
}
-(void)timerClick
{
    _timeCount-- ;
    [authCodeBtn setTitle:[NSString stringWithFormat:@"%lu秒后再次获取",(unsigned long)_timeCount] forState:UIControlStateNormal];
    if (_timeCount<=0) {
        [_timer invalidate];
        _timer  = nil;
        [authCodeBtn setBackgroundColor:NavigationBackgroundColor];
        [authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
         authCodeBtn.titleLabel.font = DefaultFontSize(15);
        _timeCount = 60;
    }
}
/*
 *下一步
 */
-(void)registerVoid
{
    if ([authCodeTextField.text isEqualToString:self.authCode]) {
        
        RegisterNextViewController * nextVC =[[RegisterNextViewController alloc] init];
        nextVC.iphoneNumber = iPhoneTextField.text;
        nextVC.authCode =self.authCode;
        nextVC.titleString = self.titleString;
        [self presentViewController:nextVC animated:YES completion:nil];
    }
    else
    {
        HUDVIEW(@"验证码错误", self.view);
        authCodeTextField.text=@"";
    }
    
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    _timeCount =60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

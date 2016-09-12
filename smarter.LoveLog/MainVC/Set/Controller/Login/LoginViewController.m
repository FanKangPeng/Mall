//
//  LoginViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/7.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomNavigationView.h"
#import "RegisterViewController.h"
#import "UserInfoTool.h"
#import "ThirdPartyLoginView.h"
#import "KeychainItemWrapper.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTextField,passWordTextField,loginBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * LoginNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [LoginNavigationView initViewWithTitle:@"登录" andBack:@"icon_back.png" andRightName:@"注册"];
    __WEAK_SELF_YLSLIDE
    LoginNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            nil;
        }];
    };
    LoginNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //注册
        [weakSelf registerBtn];
    };
    
    
    [self.view addSubview:LoginNavigationView];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    [self initView];
  
    // Do any additional setup after loading the view.
}
-(void)dissMissKeyBoard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
-(void)initView
{
    CGFloat  height =94;
    
    UIView * backView  =[[UIView alloc] initWithFrame:CGRectMake(20, height, kScreenWidth-40, 100)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.cornerRadius=5;
    backView.layer.masksToBounds =YES;
    [self.view addSubview:backView];
    height += 100;
    
    UILabel * midline  =[[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.size.height/2-SINGLE_LINE_WIDTH, backView.frame.size.width, SINGLE_LINE_WIDTH)];
    [midline setBackgroundColor:BackgroundColor];
    [backView addSubview:midline];
    
    UIImageView * userimage  =[[UIImageView alloc] initWithFrame:CGRectMake(15, backView.frame.size.height/4-10, 18, 20)];
    userimage.image =[UIImage imageNamed:@"login_icon_user"];
    [backView addSubview:userimage];
    
    userNameTextField =[[UITextField alloc] initWithFrame:CGRectMake(45,0,backView.frame.size.width-50,backView.frame.size.height/2-SINGLE_LINE_WIDTH)];
    userNameTextField.placeholder =@"已验证手机/邮箱/用户名";
    userNameTextField.delegate =self;
    userNameTextField.tag =200;
    [userNameTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    userNameTextField.keyboardType =UIKeyboardTypeNumberPad;
    userNameTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    userNameTextField.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:userNameTextField];
    
    UIImageView * pdimage =[[UIImageView alloc] initWithFrame:CGRectMake(15,backView.frame.size.height/4*3-12, 18, 20)];
    pdimage.image =[UIImage imageNamed:@"login_icon_lock"];
    [backView addSubview:pdimage];
    passWordTextField =[[UITextField alloc] initWithFrame:CGRectMake(45,backView.frame.size.height/2 ,backView.frame.size.width-100, backView.frame.size.height/2)];
    passWordTextField.placeholder =@"请输入密码";
    passWordTextField.secureTextEntry = YES;
    passWordTextField.delegate =self;
    passWordTextField.tag =201;
     [passWordTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    passWordTextField.keyboardType =UIKeyboardTypeASCIICapable;
    passWordTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    passWordTextField.textAlignment = NSTextAlignmentLeft;
        //监控事件
    [passWordTextField addTarget:self action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [backView addSubview:passWordTextField];
    
    //明文密码
    UIView * seeView =[[UIView alloc] initWithFrame:CGRectMake(backView.frame.size.width-50, backView.frame.size.height-50, 50, 50)];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seePassWord:)];
    [seeView addGestureRecognizer:tap];
    [backView addSubview:seeView];
    UIImageView * seeImage  =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_eye"]];
    seeImage.frame =CGRectMake(seeView.frame.size.width/2-10, seeView.frame.size.height/2-9, 22, 14);
    [seeView addSubview:seeImage];

    
    
    height += 30;
    //登录按钮
    loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(20, height, kScreenWidth-40, 44)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_login_Button"] forState:UIControlStateNormal];
      [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_login_Button_selected"] forState:UIControlStateSelected];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    loginBtn.userInteractionEnabled = NO;
    [self.view addSubview:loginBtn];
    
    height += 54;
    //忘记密码
    UIButton * iphoneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [iphoneBtn setFrame:CGRectMake(kScreenWidth-180,height, 160, 30)];
    [iphoneBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    iphoneBtn.titleLabel.font  =DefaultFontSize(16);
    iphoneBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [iphoneBtn setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
    [iphoneBtn addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:iphoneBtn];
    
    ThirdPartyLoginView * thirdView =[[ThirdPartyLoginView alloc] initViewWithFrame:CGRectMake(0, kScreenHeight-150, kScreenWidth, 150)];
    __WEAK_SELF_YLSLIDE
    thirdView.ThirdPartyLoginViewBlock=^(NSDictionary *data){
        [weakSelf thirdLigon:data];
    };
    thirdView.ThirdPartyLoginViewSinaBlock=^{
        //
    };
    thirdView.ThirdPartyLoginViewWeChatBlock=^{
     
    };
    [self.view addSubview:thirdView];
   
}
- (void)thirdLigon:(NSDictionary *)data
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [UserInfoTool pushThirdLoginData:@"/user/oauth" params:data success:^(id obj) {
        [hud hide:YES];
        if (isLogin) {
            HUDVIEW(@"登录成功", self.view);
            NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[obj objectForKey:@"userDict"]];
            [userInfoDict setObject:[[obj objectForKey:@"userDict"] objectForKey:@"user_name"] forKey:@"name"];
            //把用户信息存储到keyChain中
            NSMutableData* data = [[NSMutableData alloc]init];
            NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:userInfoDict forKey:@"userInfoModel"];
            [archiver finishEncoding];
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfoModel"];
            //   self.updataLoginBlock();
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([[obj objectForKey:@"complete"] isEqualToString:@"1"]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
                    }];
                }else
                {
                    //完善用户信息
                }
               
            });
        }
        else
            HUDVIEW(@"登录失败", self.view);
    } failure:^(id obj) {
          [hud hide:YES];
        if(![obj isKindOfClass:[NSError class]])
            HUDVIEW([obj objectForKey:@"error_desc"], self.view);
        else
            HUDVIEW(@"登录失败", self.view);
    }];
}
/**
 password监控事件
 */
-(void)passwordTextFieldChange:(UITextField*)textField
{
    if(textField.text.length>=6 &&textField.text.length<=14)
    {
        loginBtn.selected =YES;
        loginBtn.userInteractionEnabled = YES;
    }
    else
    {
        loginBtn.selected=NO;
        loginBtn.userInteractionEnabled = NO;
    }
}
/**
 登录
 */
-(void)login
{
    if(userNameTextField.text.length==0)
    {
        HUDVIEW(@"请输入用户名", self.view);
        passWordTextField.text =@"";
        userNameTextField.text=@"";
    }
    else
    {
        if(IS_A_PASSWORLD(passWordTextField.text)==YES)
        {
            //登录
            [self postUserInfo];
        }
        else
        {
            HUDVIEW(@"密码错误", self.view);
            passWordTextField.text =@"";
        }
    }
   
}
/**
 登录事件
 */
-(void)postUserInfo
{
    [self.view endEditing:YES];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    [UserInfoTool Login:@"/user/signin" params:@{@"account":userNameTextField.text,@"password":passWordTextField.text} success:^(id obj) {
        [hud hide:YES];
        
        if (isLogin) {
            HUDVIEW(@"登录成功", self.view);
            NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionaryWithDictionary:obj];
            [userInfoDict setObject:[obj objectForKey:@"user_name"] forKey:@"name"];
            //把用户信息存储到keyChain中
            NSMutableData* data = [[NSMutableData alloc]init];
            NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:userInfoDict forKey:@"userInfoModel"];
            [archiver finishEncoding];
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfoModel"];
            //   self.updataLoginBlock();
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
                }];
            });
        }
        else
            HUDVIEW(@"登录失败", self.view);
        
    } failure:^(id obj) {
          [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
            HUDVIEW([obj objectForKey:@"error_desc"], self.view);
        else
             HUDVIEW(@"登录失败", self.view);
    }];
}
/**
 注册
 */
-(void)registerBtn
{
    RegisterViewController * registerVC  =[[RegisterViewController alloc] init];
    registerVC.titleString =@"注册";
    [self presentViewController:registerVC animated:YES completion:nil];
}

-(void)seePassWord:(UITapGestureRecognizer*)tap
{
    
    if(passWordTextField.secureTextEntry)
    {
        passWordTextField.secureTextEntry = NO;
    }
    else
    {
        passWordTextField.secureTextEntry =YES;
    }
    
}
-(void)forgetPassWord
{
    RegisterViewController * registerVC  =[[RegisterViewController alloc] init];
    registerVC.titleString =@"找回密码";
    [self presentViewController:registerVC animated:YES completion:nil];
}
#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL isNull;
    if(textField.tag==201)
    {
        if(userNameTextField.text.length==0)
        {
            isNull= NO;
             HUDVIEW(@"请输入用户名", self.view);
        }
        else
        {
//            if(IS_USERNAME(userNameTextField.text) == NO)
//            {
//                isNull= NO;
//                 HUDSHOW(@"手机号错误");
//            }
//            else
                isNull= YES;
        }
       
    }
    else
        isNull = YES;
    return isNull;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

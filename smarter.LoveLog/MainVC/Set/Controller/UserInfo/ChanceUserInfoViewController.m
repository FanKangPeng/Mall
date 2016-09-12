//
//  ChanceUserInfoViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "ChanceUserInfoViewController.h"
#import "UserInfoTool.h"
#import "MyKeyChainHelper.h"
@interface ChanceUserInfoViewController ()

@end

@implementation ChanceUserInfoViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:self.titleString andBack:@"icon_back.png" andRightName:@"保存"];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
        
        double delayInSeconds =[firstResponderView isFirstResponder] ? 1.0 :0;
        [self.view endEditing:YES];
    
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lcNavigationController popViewController];
        });
    };
    setNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf save];
    };
    [self.view addSubview:setNavigationView];
    
    if ([self.titleString isEqualToString:@"修改性别"]) {
        [self chanceSex];
    }
    if ([self.titleString isEqualToString:@"修改用户名"]) {
        alertString=@"修改用户名成功，请使用新用户名重新登录";
        [self chanceName];
    }
    if ([self.titleString isEqualToString:@"绑定手机号"]) {
          alertString=@"绑定手机号成功，请重新登录";
        [self addIphoneNum];
    }
    if ([self.titleString isEqualToString:@"修改绑定手机号"]) {
          alertString=@"修改手机号成功，请重新登录";
        [self chanceIphoneNum];
    }
    if ([self.titleString isEqualToString:@"修改密码"]) {
          alertString=@"修改用密码成功，请重新登录";
        [self chanceUserPwd];
    }
    
    // Do any additional setup after loading the view.
}

-(BOOL)opinopn
{
    paramsDict = [NSDictionary dictionary];
    if ([self.titleString isEqualToString:@"修改性别"]) {
        
        paramsDict =@{@"action":@"sex",@"sex":[NSString stringWithFormat:@"%ld",(long)sexSelectIndex]};
        return YES;
        
    }
    
    if ([self.titleString isEqualToString:@"修改用户名"]) {
        if (!userName) {
            HUDSHOW(@"请输入用户名");
            return NO;
        }
        else
        {
            paramsDict =@{@"action":@"user_name",@"user_name":userName};
            return YES;
        }
     
        
    }
    if ([self.titleString isEqualToString:@"修改密码"]) {
    
        if (!oldPWD) {
            HUDSHOW(@"请输入原密码");
            return NO;
        }
        else if (!newPWD) {
            HUDSHOW(@"请输入新密码");
            return NO;
        }
        else
        {
            paramsDict=@{@"action":@"change_pwd",@"old_password":oldPWD,@"new_password":newPWD};
            return YES;
        }
        
    }
    return YES;
}
-(void)save
{
    [self.view  endEditing:YES];
    if ([self opinopn]) {
        [UserInfoTool userInfo:@"/user/modify" params:paramsDict success:^(id obj) {
            HUDSHOW(@"修改成功");
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([self.titleString isEqualToString:@"修改密码"] ||[self.titleString isEqualToString:@"修改用户名"]) {
                    //清除本地缓存的信息 退出登录
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
                    [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeportraitImageView" object:[UIImage imageNamed:@"userInfo_portrait_icon.jpg"]];
                    [self.lcNavigationController popViewControllerCompletion:^{
                        CustomAlertView * alert =  [[CustomAlertView alloc] initWithTitle:alertString message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
                        alert.delegate =self;
                        [alert show];
                    }];
                }
                else
                    [self.lcNavigationController popViewController];
            });
        } failure:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * err = obj;
                HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
            else
                HUDSHOW([obj objectForKey:@"error_desc"]);
        }];

    }
    
    
    }
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [customAlertView hide];
    }
    else
    {
      [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
    }
}
-(void)chanceSex
{
    UITableView * sexList =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, 132) style:UITableViewStylePlain];
    [sexList setBackgroundColor:[UIColor whiteColor]];
    [sexList setDelegate:self];
    sexList.dataSource=self;
    [self.view addSubview:sexList];
    if([sexList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [sexList setSeparatorInset:UIEdgeInsetsZero];
    }
    if([sexList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [sexList setLayoutMargins:UIEdgeInsetsZero];
    }
    sexList.scrollEnabled = NO;
    sexSelectIndex = [self.userInfoModel.sex integerValue];
}
-(void)chanceName
{
    UITextField * textField =[[UITextField alloc] initWithFrame:CGRectMake(KLeft, kNavigationHeight+10, kScreenWidth-KLeft*2, 44)];
    textField.text =self.userInfoModel.name;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = DefaultFontSize(15);
    [textField becomeFirstResponder];
    textField.delegate =self;
    [self.view addSubview:textField];
    
}
-(void)chanceUserPwd
{
    UITextField * textField =[[UITextField alloc] initWithFrame:CGRectMake(KLeft, kNavigationHeight+10, kScreenWidth-KLeft*2, 44)];
    textField.borderStyle=UITextBorderStyleRoundedRect;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = DefaultFontSize(15);
    textField.delegate =self;
    textField.tag =300;
    textField.secureTextEntry = YES;
    textField.placeholder=@"请输入您原密码";
    [textField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:textField];
    
    
    UITextField * textField1 =[[UITextField alloc] initWithFrame:CGRectMake(KLeft, textField.bottom+10, kScreenWidth-KLeft*2, 44)];
    textField1.borderStyle=UITextBorderStyleRoundedRect;
    [textField1 setBackgroundColor:[UIColor whiteColor]];
    textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField1.font = DefaultFontSize(15);
    textField1.delegate =self;
    textField1.tag=400;
    textField1.secureTextEntry = YES;
    textField1.placeholder=@"请输入您新密码";
    [textField1 setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:textField1];


}
-(void)chanceIphoneNum
{
    
}
-(void)addIphoneNum
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.textColor = FontColor_black;
    cell.textLabel.font = DefaultFontSize(15);
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=@"保密";
            break;
        case 1:
            cell.textLabel.text=@"男";
            break;
        case 2:
            cell.textLabel.text=@"女";
            break;
      
            
        default:
            break;
    }
    
    if (sexSelectIndex==indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    sexSelectIndex =  indexPath.section;
    [tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark  textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==300) {
        if (textField.text.length<=0) {
           
            return NO;
        }
        else
        {
            oldPWD= textField.text;
            return YES;
        }
    }
    else if (textField.tag==400)
    {
        if (IS_A_PASSWORLD(textField.text)) {
        
            return NO;
        }
        else
        {
            newPWD =textField.text;
            return  YES;
        }
    }
    else
    {
        if (textField.text.length>0) {
            userName= textField.text;
            [textField resignFirstResponder];
            return YES;
        }
        else
            return NO;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==300) {
      
            oldPWD= textField.text;
            return YES;
        
    }
    else if (textField.tag==400)
    {
        newPWD =textField.text;
        return  YES;
    }
    else
    {
            userName= textField.text;
            [textField resignFirstResponder];
            return YES;
    }

}
@end

//
//  ThirdPartyLoginView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/14.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ThirdPartyLoginView.h"
#import <ShareSDK/ShareSDK.h>

#define ThirdBtnWidth (kScreenWidth-70)/3

@implementation ThirdPartyLoginView
-(instancetype)initViewWithFrame:(CGRect)Frame
{
    self =[super initWithFrame:Frame];
    UIImageView * leftImage  =[[UIImageView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth/2 -38, SINGLE_LINE_WIDTH)];
    leftImage.image =[UIImage imageNamed:@"login_third_left_wire"];
    [self addSubview:leftImage];
    
    UIImageView * rightImage  =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 +38, 15, kScreenWidth/2 -38, SINGLE_LINE_WIDTH)];
    rightImage.image =[UIImage imageNamed:@"login_third_right_wire"];
    [self addSubview:rightImage];
    
    UILabel * threeLabel  =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-35, 0, 70, 30)];
    [threeLabel setText:@"第三方登录"];
    [threeLabel setFont:DefaultFontSize(14)];
    [threeLabel setTextColor:[UIColor blackColor]];
    [self addSubview:threeLabel];
   
     for (int i =0; i<3;i++)
     {
         UIView * backView =[[UIView alloc] initWithFrame:CGRectMake(35+ThirdBtnWidth*i, self.frame.size.height/2 - ThirdBtnWidth/2,ThirdBtnWidth, ThirdBtnWidth)];
         
     UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
     [button setFrame:CGRectMake(15, 15,ThirdBtnWidth-30,ThirdBtnWidth-30)];
     [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_third_icon_0%d",i]] forState:UIControlStateNormal];
     [button setTag:i+200];
     [button addTarget:self action:@selector(threeLogin:) forControlEvents:UIControlEventTouchDown];
     [backView addSubview:button];
         [self addSubview:backView];
     }


    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)threeLogin:(UIButton *)button
{
    switch (button.tag-200) {
        case 0:
            [self weChatLogin];
            break;
        case 1:
            [self QQLogin];
            break;
        case 2:
            [self sinaLogin];
            break;
        default:
            break;
    }
}
/**
 微信登录
 */
-(void)weChatLogin
{
    //判断是否授权
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession])
    {
        [self loginSuccess:ShareTypeWeixiSession];
    }
    else
    {
        //授权
        [self authWithType:ShareTypeWeixiSession];
        
    }
    
}
//授权成功登录回调
-(void)loginSuccess:(ShareType)sender
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:sender];
    
    NSLog(@"uid : %@ , token : %@",credential.uid,credential.token);
    
    
    [self getUserInfo:sender];
    
}
//对平台授权
- (void)authWithType:(ShareType)sender
{
    [ShareSDK authWithType:sender
                   options:nil
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {
                        
                        switch (state)
                        {
                            case SSAuthStateBegan:
                                NSLog(@"begin to auth");
                                break;
                            case SSAuthStateSuccess:
                            {
                                [self getUserInfo:sender];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                message:nil
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                                [alert show];
                               
                            }
                                break;
                            case SSAuthStateCancel:
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel"
                                                                                message:nil
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                                [alert show];
                            }
                                break;
                            case SSAuthStateFail:
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                                message:[NSString stringWithFormat:@"error code: %zi,error description: %@",[error errorCode],[error errorDescription]]
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                                [alert show];
                            }
                                break;
                            default:
                                break;
                        }
                    }];
}

//获取用户信息
- (void)getUserInfo:(ShareType)sender
{
    [ShareSDK getUserInfoWithType:sender
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *type = @"";
                                   switch (sender) {
                                       case ShareTypeSinaWeibo:
                                           type = @"weibo";
                                           break;
                                       case ShareTypeQQSpace:
                                           type = @"qq";
                                           break;
                                       case ShareTypeQQ:
                                           type = @"qq";
                                           break;
                                       case ShareTypeWeixiSession:
                                           type = @"wechat";
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                                   NSDictionary * data =[NSDictionary dictionaryWithDictionary:[userInfo sourceData]] ;
                                   _ThirdPartyLoginViewBlock(@{@"type":type,@"data":data});
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                                                   message:[NSString stringWithFormat:@"userInfo:%@",[userInfo sourceData]]
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"OK"
//                                                                         otherButtonTitles:nil, nil];
//                                   [alert show];
                                  
                               }
                               else
                               {
                                   HUDSHOW([error errorDescription]);
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
//                                                                                   message:[NSString stringWithFormat:@"error code: %zi,error description: %@",[error errorCode],[error errorDescription]]
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"OK"
//                                                                         otherButtonTitles:nil, nil];
//                                   [alert show];
                               }
                           }];
}
/**
 QQ登录
 */
-(void)QQLogin
{
    //判断是否授权
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
    {
        [self loginSuccess:ShareTypeQQSpace];
    }
    else
    {
        //授权
        [self authWithType:ShareTypeQQSpace];
        
    }
}
/**
 新浪微博登录
 */
-(void)sinaLogin
{
    //判断是否授权
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
    {
        [self loginSuccess:ShareTypeSinaWeibo];
    }
    else
    {
        //授权
        [self authWithType:ShareTypeSinaWeibo];
        
    }
}



@end

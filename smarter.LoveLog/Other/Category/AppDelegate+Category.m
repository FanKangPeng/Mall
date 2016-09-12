//
//  AppDelegate+Category.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AppDelegate+Category.h"
#import <ShareSDK/ShareSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "WXApiManager.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "RCDLoginInfo.h"





@implementation AppDelegate (Category)
-(void)initAppdelegate
{
    //设置状态栏颜色 白色 显示状态栏
    
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
    [self initializeShareSDK];
    
 
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

-(void)initializeShareSDK
{
    //1.初始化ShareSDK应用,字符串"5559f92aa230"换成http://www.mob.com/后台申请的ShareSDK应用的Appkey
    
    [ShareSDK registerApp:@"ce74aea11a90"];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"3044356740"
                               appSecret:@"8c7505d85cfb487bb2c0b51988fe97ac"
                             redirectUri:@"http://www.aiderizhi.com"
                             weiboSDKCls:[WeiboSDK class]];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
     appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
     redirectUri:@"http://www.aiderizhi.com/mapp/?url=/user/signinm"];
     **/
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1105000062"
                           appSecret:@"uK9qmMOsoKeudlRv"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx33496a68219a3769"
                           appSecret:@"9928dececd0520b0cb6cde3aac4f40d1"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    [ShareSDK connectQQWithQZoneAppKey:@"1105000062"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    //连接邮件
    [ShareSDK connectMail];

}


@end

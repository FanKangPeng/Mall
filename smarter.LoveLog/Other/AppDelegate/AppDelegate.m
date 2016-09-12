//
//  AppDelegate.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//




#import "AppDelegate.h"
#import "UIWindow+Category.h"
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

#import "ChatViewController.h"
#import "RCDLoginInfo.h"
#import "JPUSHService.h"
#import "NotReachView.h"
#import "UIViewController+Category.h"
//银联支付
#import "UPPaymentControl.h"
#import "IVar.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
   // [IVar ivarsdfsd];
    
    
        // 设置rootview
        self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
        self.mainViewController = [[ViewController alloc] init];
        self.window.rootViewController = self.mainViewController;
        [self.window makeKeyAndVisible];
    
    NSString * versionString =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * cacheVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    if([cacheVersion isEqualToString:versionString])
    {
        [self.window showLanuchPage];
    }
    else
    {
        //情况本地数据库  避免因缓存  造成数据库的改动后错误的问题
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"version"];
        [[NSUserDefaults standardUserDefaults] setObject:versionString forKey:@"version"];
    }

    
    
        [self initAppdelegate];
        //初始化融云SDK
        [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
        [self initPushWithapplication:application launchOptions:launchOptions];


    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
   
    
    
}
-(void)initPushWithapplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel apsForProduction:isProduction];
    
//    /**
//     * 推送处理1
//     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
     
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:myTypes categories:nil]];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:application];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    

        //跳转聊天的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatAction:) name:KNOTIFICATION_CHAT object:nil];
    
    //跳转登录的通知帖子
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logIn:) name:LogIn object:nil];
}
-(void)logIn:(NSNotification*)notification
{
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}
- (void)chatAction:(NSNotification *)notification
{
    if([[RCIMClient  sharedRCIMClient]getConnectionStatus] !=ConnectionStatus_Connected)
    {
        [[RCDLoginInfo shareLoginInfo] ChatLogin];
    }
    
    ChatViewController * chatViewController =[[ChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_APPSERVICE;
    chatViewController.targetId = @"KEFU145016175783968";
    chatViewController.title = @"在线客服";
    UINavigationController * navigation =[[UINavigationController alloc] initWithRootViewController:chatViewController];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:navigation animated:YES completion:nil];
    
}
//此方法一定会执行 在mainViewControllrt 初始化之前
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    //判断通知是否打开 没打开提醒打开
  if([application isRegisteredForRemoteNotifications])
  {
      FLog(@"未打开通知");
  }
    FLog(@"收到通知");
}
// 此方法执行时  mainViewController已经初始化完成 可以做页面跳转工作
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    FLog(@"收到通知");
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    //图标数字
    UIApplication * app = notification.object;
    if(app.applicationState == UIApplicationStateBackground)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
 
}
#pragma mark
#pragma rongyun
/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
     FLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSString * alertText;
    
    if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
        alertText = @"亲，您的手机网络不顺畅哦！";
      
      
    }
    if (status == ConnectionStatus_Cellular_3G_4G  || status == ConnectionStatus_Cellular_2G) {
        alertText = @"切换到蜂窝移动网络";
        
    }
    if (status == ConnectionStatus_WIFI) {
        alertText = @"切换到WIFI";
        
    }
    
   
    
    
    if(alertText.length>0)
    {
        MBProgressHUD*  HUD = [[MBProgressHUD alloc] initWithView:self.window.rootViewController.view];
        [self.window.rootViewController.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeText;
        
        HUD.labelText = alertText;
        
         HUD.yOffset = kScreenHeight/3;
        
        [HUD show:YES];
        
        [HUD hide:YES afterDelay:1];
        
        /*
        double delayInSeconds =2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (status == ConnectionStatus_Cellular_3G_4G ||  status == ConnectionStatus_Cellular_2G ||status == ConnectionStatus_WIFI) {
                if (self.status == ConnectionStatus_NETWORK_UNAVAILABLE) {
                    [self netWorkReagain];
                }
            }
            
            self.status = status;
        });
        */
         self.status = status;
    }
    
}
/*
- (void)netWorkReagain
{
    UIViewController * isDisplayVC = [[UIViewController new] getCurrentVC];
    
    for (UIView * view  in isDisplayVC.view.subviews) {
        if ([view isKindOfClass:[NotReachView class]]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkRenew" object:nil];
        }
    }

}
 */


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_APPSERVICE)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
/**程序被激活调用    当网络从中断到恢复的时候 会调用*/
- (void)applicationDidBecomeActive:(UIApplication *)application {

   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "FanKing.LovesLOG" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LovesLOG" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LovesLOG.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] rangeOfString:@"UPPayLoveLog"].location != NSNotFound) {
        //银联支付回调
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //判断签名数据是否存在
                
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    
                    return;
                }
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                
                
                //验签证书同后台验签证书
                //此处的verify，商户需送去商户后台做验签
                //if([self verify:sign]) {
                if ([PayViewController verify:sign]) {
                    //支付成功且验签成功，展示支付成功提示
                    [PayViewController showPayResult:@"支付成功"];
                }
                else {
                    [PayViewController payStatus];
                    //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                }
                
                
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                [PayViewController showPayResult:@"支付失败"];
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                [PayViewController showPayResult:@"支付取消"];
            }
        }];
        return YES;
    }
    else if([[url absoluteString] rangeOfString:@"wechatpay"].location !=NSNotFound)
    {
        //微信支付回调
        return   [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if([[url absoluteString] rangeOfString:@"alipaySchemes"].location !=NSNotFound)
    {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            FLog(@"result == %@",resultDic);
            if([resultDic[@"resultStatus"] intValue] == 9000)
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:resultDic];
            else
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailure" object:resultDic];
        }];
        [[AlipaySDK defaultService]processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            FLog(@"result == %@",resultDic);
            if([resultDic[@"resultStatus"] intValue] == 9000)
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:resultDic];
            else
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailure" object:resultDic];
        }];
        return YES;
    }else
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:@"UPPayLoveLog"].location != NSNotFound) {
        //银联支付回调
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                //判断签名数据是否存在
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    return;
                }
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //验签证书同后台验签证书
                //此处的verify，商户需送去商户后台做验签
                //if([self verify:sign]) {
                    if ([PayViewController verify:sign]) {
                        //支付成功且验签成功，展示支付成功提示
                        [PayViewController showPayResult:@"支付成功"];
                    }
                    else {
                        [PayViewController payStatus];
                        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                    }
               
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                [PayViewController showPayResult:@"支付失败"];
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                [PayViewController showPayResult:@"支付取消"];
            }
        }];
        return YES;
    }
    else if([[url absoluteString] rangeOfString:@"wechatpay"].location !=NSNotFound)
    {
        //微信支付回调
     return   [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if([[url absoluteString] rangeOfString:@"alipaySchemes"].location !=NSNotFound)
    {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            FLog(@"result == %@",resultDic);
             if([resultDic[@"resultStatus"] intValue] == 9000)
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:resultDic];
            else
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailure" object:resultDic];
        }];
        [[AlipaySDK defaultService]processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             FLog(@"result == %@",resultDic);
            if([resultDic[@"resultStatus"] intValue] == 9000)
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:resultDic];
            else
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailure" object:resultDic];
        }];
        return YES;
    }else
         //分享第三方登录回调
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
}



@end


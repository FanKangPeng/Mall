//
//  WXApiManager.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "WXApiManager.h"
 #import "CustomAlertView.h"
#import "PayTools.h"
@implementation WXApiManager
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
+ (void)startWeChatPay:(NSDictionary *)dict callBlcok:(CallBlock)callBlock
{
    
    
    
    
    HUDSHOW(@"微信支付Demo不能使用");
  //  NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = [dict objectForKey:@"partnerid"];
//    req.prepayId            = [dict objectForKey:@"prepayid"];
//    req.nonceStr            = [dict objectForKey:@"noncestr"];
//    req.timeStamp           = stamp.intValue;
//    req.package             = [dict objectForKey:@"package"];
//    req.sign                = [dict objectForKey:@"sign"];
    
//    [WXApi sendReq:req];
//    
//    [WXApiManager sharedManager].WXPayBlock = ^(id obj){
//        callBlock(obj);
//    };
 
}
+ (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
   if([resp isKindOfClass:[PayResp class]]){
  
        //支付返回结果，实际支付结果需要去微信服务器端查询
       NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeCommon:
                strMsg = @"支付失败";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeUserCancel:
                strMsg = @"取消支付";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
       //根据结果处理去请求
       _WXPayBlock(strMsg);

    }
  
}
@end

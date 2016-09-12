//
//  AlipayManager.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "PayViewController.h"
@implementation AlipayManager
+ (void)startAliPay:(NSDictionary *)dict success:(CallBlock)success failure:(CallBlock)failure
{
    FLog(@"%@",dict);
    NSString *partner = [dict  objectForKey:@"partner"];
    NSString *seller = [dict objectForKey:@"seller_id"];
    NSString *privateKey = PartnerPrivateKey;// [[dict objectForKey:@"partner_info"] objectForKey:@"PartnerPrivKey"];
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [dict objectForKey:@"out_trade_no"]; //订单ID（由商家自行制定）
    order.productName = [dict objectForKey:@"subject"]; //商品标题
    order.productDescription = [dict objectForKey:@"body"]; //商品描述
    order.amount =[dict objectForKey:@"total_fee"];// [NSString stringWithFormat:@"%.2f",[[orderData objectForKey:@"Amount"] floatValue]]; //商品价格
    order.notifyURL = [dict objectForKey:@"notify_url"]; //回调URL
    
    order.service = [dict objectForKey:@"service"];
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay =[dict objectForKey:@"it_b_pay"];
  //  order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipaySchemes";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
  id<DataSigner> signer = CreateRSADataSigner(privateKey);
  NSString *signedString = [signer signString:orderSpec];
   
//    NSString * signedString = [dict objectForKey:@"sign"];
     FLog(@"sign == %@",signedString);
    NSString *sign_type = [dict objectForKey:@"sign_type"];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, sign_type];
       
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
          
        }];
    }else
        HUDSHOW(@"数据异常");
}

@end

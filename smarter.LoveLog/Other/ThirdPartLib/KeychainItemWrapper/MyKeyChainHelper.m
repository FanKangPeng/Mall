//
//  MyKeyChainHelper.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MyKeyChainHelper.h"
#import <Security/Security.h>
@implementation MyKeyChainHelper
+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)(kSecClassGenericPassword),kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,nil];
    
}
+ (void)saveSession:(NSDictionary *)session andSessionService:(NSString *)sessionService
{
    
    [[NSUserDefaults standardUserDefaults] setObject:session forKey:sessionService];
    
    
//    
//    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:sessionService];
//    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
//    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:session]
//                      forKey:(__bridge id<NSCopying>)(kSecValueData)];
//    SecItemAdd((__bridge CFDictionaryRef)(keychainQuery), NULL);
    

}
+ (NSDictionary *)getSession:(NSString *)sessionService
{
    
    NSDictionary * session = [[NSUserDefaults standardUserDefaults] objectForKey:sessionService];
    
    FLog(@"mysession is :%@",session);
    
    return session;
    
//    id ret = nil;
//    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:sessionService];
//    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
//    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
//    
//    CFTypeRef result = NULL;
//    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, &result) == noErr)
//    {
//        FLog(@"keyChain 读取成功");
//        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)result];
//    }
//    else
//       FLog(@"keyChain 读取失败");
//    return ret;
    
}
+ (void)deleteSession:(NSString *)sessionService
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:sessionService];
//    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:sessionService];
//    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end

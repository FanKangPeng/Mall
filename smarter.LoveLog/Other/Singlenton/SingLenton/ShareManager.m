//
//  ShareManager.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ShareManager.h"
#import<ShareSDK/ShareSDK.h>
@implementation ShareManager
+(ShareManager *) sharedInstance{
    
    static ShareManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}
-(void)createShareContentWithShareDict:(NSDictionary*)dict andShareView:(UIView *)view
{
    if (!dict) {
        dict =@{@"thumb":@"",@"desc":@"爱的日志分享",@"title":@"爱的日志",@"url":@"http://www.aiderizhi.com/"};
       
    }
     [self createShareContent:dict andShareView:view];
}
-(void)createShareContent:(NSDictionary*)dict andShareView:(UIView *)view
{
    NSString * imgUrl  = [dict objectForKey:@"thumb"];
    if ([imgUrl isEqualToString:@""]) {
        imgUrl = @"http://www.aiderizhi.com/uploads/slider/1460395846075519102.jpg";
    }
    
        
    id<ISSCAttachment> remoteAttachment = [ShareSDKCoreService attachmentWithUrl:imgUrl];
    //    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"]];
    
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    id<ISSContent> publishContent = [ShareSDK content:[dict objectForKey:@"desc"]
                                       defaultContent:nil
                                                image:remoteAttachment
                                                title:[dict objectForKey:@"title"]
                                                  url:[dict objectForKey:@"url"]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    
    
    
    //1.5、分享菜单栏选项排列位置和数组元素index相关(非必要)
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          nil];
    
    
    //1+、创建弹出菜单容器（iPad应用必要，iPhone应用非必要）
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、展现分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    HUDSHOW(@"分享成功");
                                                                   }
                                else if (state == SSResponseStateFail)
                                {
                                   
                                     HUDSHOW(@"分享失败");
                                }
                            }];
}

@end

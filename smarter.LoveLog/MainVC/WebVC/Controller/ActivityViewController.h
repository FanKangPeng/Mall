//
//  ActivityViewController.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "SecondBaseViewController.h"

#import "Action.h"


@interface ActivityViewController : SecondBaseViewController<UIWebViewDelegate>
{
    
    UIWebView *_activityWeb;

    
}
@property(nonatomic,strong)MBProgressHUD  * mbProgressHud;
@property (nonatomic,copy)void (^ActivityVC)(NSString *back);
@property (nonatomic ,strong) NSString * url ;
@property (nonatomic,assign) BOOL  isWebActivity;
@property(nonatomic,strong)UIButton * cancelButton;
@property (nonatomic ,assign ) BOOL  isSizeTofite;
@end

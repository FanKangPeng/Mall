//
//  ChanceUserInfoViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "UserInfoModel.h"
#import "CustomAlertView.h"

@interface ChanceUserInfoViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomAlertViewDelegate>
{
    NSInteger  sexSelectIndex;
    NSString * userName;
    NSString * oldPWD;
    NSString * newPWD;
    NSDictionary * paramsDict;
    NSString * alertString;
}
@property(nonatomic,copy)NSString * titleString;
@property(nonatomic,strong)UserInfoModel * userInfoModel;



@end

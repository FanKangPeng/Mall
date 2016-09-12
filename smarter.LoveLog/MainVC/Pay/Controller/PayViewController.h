//
//  PayViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
 #import "CustomAlertView.h"
#import "PayHeadView.h"
@interface PayViewController : SecondBaseViewController<CustomAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger paytype;
}
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)PayHeadView * tableViewHeadView;
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)NSArray * images;
@property (nonatomic ,strong) NSDictionary * orderData;
@property(nonatomic,strong)NSString * order_id;
//验证支付结果
+ (void)payStatus;
//处理支付返回结果提示
+ (void)showPayResult:(NSString *)result;
//验证签名
+ (BOOL)verify:(NSString *)sign;
@end

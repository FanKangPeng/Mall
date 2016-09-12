//
//  AdressManagerViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "AddressModel.h"
#import "CustomAlertView.h"
@interface AdressManagerViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,CustomAlertViewDelegate>

@property(nonatomic,strong)NSMutableArray * contentArr;
@property(nonatomic,strong)UITableView * addressList;
@property (nonatomic ,strong) AddressModel * addressModel;
@property (nonatomic ,assign) BOOL cellCanSeleted;
@property (nonatomic ,copy) NSString *usedModedID;
@property (nonatomic ,copy) void(^AdressBlock)(NSString * adressID);

@end

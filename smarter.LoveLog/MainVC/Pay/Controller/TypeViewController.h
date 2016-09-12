//
//  TypeViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface TypeViewController : SecondBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * contentArr;
    NSMutableDictionary  *selectedData;
}

@property (nonatomic ,strong) UITableView *listView;

@property (nonatomic ,strong) NSDictionary *dataDict;

@property (nonatomic ,strong) UIButton * sureBtn;

@property (nonatomic ,copy) void (^TypeVCBlock)(NSDictionary *selecteData);

@end

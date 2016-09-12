//
//  SetViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
 #import "CustomAlertView.h"

@interface SetViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,CustomAlertViewDelegate>
{
    NSMutableArray * titleArr;
    NSMutableArray * contentArr;
    NSMutableArray * imageArr;
}
@property(nonatomic,strong)UITableView * listView;


@end

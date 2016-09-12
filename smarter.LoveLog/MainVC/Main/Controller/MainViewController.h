//
//  MainViewController.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
/**列表*/
@property (nonatomic,strong)UITableView * mainTabelView ;

@end

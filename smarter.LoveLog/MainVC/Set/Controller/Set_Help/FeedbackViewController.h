//
//  FeedbackViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface FeedbackViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong) CustomNavigationView * setNavigationView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong) NSArray * titleArr;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UITextField *numberTextField;
@property(nonatomic,strong)UITextView *contentTextView;
@end

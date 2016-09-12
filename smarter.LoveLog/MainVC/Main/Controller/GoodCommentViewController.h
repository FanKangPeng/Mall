//
//  GoodCommentViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"

@interface GoodCommentViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableDictionary * commentDict;
@property (nonatomic,strong)UITableView *estimateListView;
@property(nonatomic,strong)NSString * good_id;
@property(nonatomic,assign)NSUInteger pageCount;
@property (nonatomic,strong)UIView * tabView;
@property (nonatomic,strong)UITextField* commeunityTextField;
@property (nonatomic,strong)UIButton * sendButton;
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
/**写评论按钮*/
@property(nonatomic,strong)UIButton * writeCommentButton;
@end

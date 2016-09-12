//
//  GoodCommentViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/25.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "GoodCommentViewController.h"
#import "GoodsTool.h"
#import "EstimateTableViewCell.h"
#import "EstimateModel.h"
#import "CommunityTool.h"
#import "WriteCommentViewController.h"
@interface GoodCommentViewController ()

@end

@implementation GoodCommentViewController
#pragma mark - lefe Cycle
- (void)viewWillAppear:(BOOL)animated
{
    if (_noDataView || _noreachView || _estimateListView) {
        [self getData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"所有评论" andBack:@"icon_back.png" andRightName:@"写评论"];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf.lcNavigationController popViewController];
    };
    NavigationView.CustomNavigationCustomRightBtnBlock = ^(UIButton *rightBtn){
        [weakSelf writeCommentButton:nil];
    };
    _pageCount=1;
    [self.view addSubview:NavigationView];
    if(!_writeCommentButton)
    {
        [self.view  addSubview:self.writeCommentButton];
        [self.view bringSubviewToFront:self.writeCommentButton];
    }
    
//    [self.view addSubview:self.tabView];
//    [self.view bringSubviewToFront:self.tabView];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)initView
{
   
    if(!_estimateListView)
    {
        [self.view addSubview:self.estimateListView];
        [self.view sendSubviewToBack:self.estimateListView];
    }
    else
    {
        [self.estimateListView.mj_footer endRefreshing];
        [self.estimateListView.mj_header endRefreshing];
        [self.estimateListView reloadData];
    }
}
-(void)removeView
{
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(_noDataView)
    {
        [_noDataView removeFromSuperview];
        _noDataView= nil;
    }
}
-(void)initFailView:(id)error
{
    
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] init];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getData];
        };
        [self.view addSubview:_noreachView];
        [self.view sendSubviewToBack:_noreachView];
    }
}
-(void)initNodataView
{
    
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight)];
        _noDataView.CAPION =@"暂无评价";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [self.view addSubview:_noDataView];
        [self.view sendSubviewToBack:_noDataView];
    }
}


#pragma mark - server methods

-(void)sendComment
{
    
    [_commeunityTextField resignFirstResponder];
    if(_commeunityTextField.text.length<=0)
    {
        HUDSHOW(@"呱唧几句吧亲");
    }
    else
    {
        [CommunityTool addComment:@"/comment/add" params:@{@"type":@"0",@"id":self.good_id,@"reply_id":@"",@"content":_commeunityTextField.text,@"rank":@"4"} success:^(id obj) {
            [_commeunityTextField setText:@""];
            [self getData];
        } failure:^(id obj) {
            if([obj isKindOfClass:[NSError class]])
            {
                NSError * err = obj;
                
                HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
            else
            {
                
                if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                    
                }
                else
                {
                    HUDSHOW([obj objectForKey:@"error_desc"]);
                }
                
            }
            
        }];
    }
    
}
-(void)getData
{
    [_noDataView.mj_header endRefreshing];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [GoodsTool getComment:@"/comment/list" params:@{@"type":@"0",@"id":self.good_id} success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.commentDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSArray * array =[self.commentDict objectForKey:@"comment"];
        if (array) {
            [self initView];
        }
        else
            [self initNodataView];
    } failure:^(id obj) {
        [hud hide: YES];
        [self removeView];
        if ([obj isKindOfClass:[NSError class]]) {
            
            NSError * err =obj;
            if ([[err.userInfo  objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
                [self initNodataView];
            }
            else
                [self initFailView:obj];
            
        }
        else
        {
            HUDSHOW([obj objectForKey:@"error_desc"]);
        }
    }];
    
}
-(void)loadMore
{
    NSNumber * allCount = [[self.commentDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        NSDictionary * dict=@{@"type":@"0",@"id":self.good_id,@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
        
        
        [GoodsTool getCommentMoreDate:@"/comment/list" params:dict success:^(id obj) {
            
            NSMutableArray * communityArr =[self.commentDict objectForKey:@"comment"];
            [communityArr addObjectsFromArray:[obj objectForKey:@"comment"]];
            
            [self.commentDict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [self.commentDict setObject:communityArr forKey:@"comment"];
            
            [self initView];
        } failure:^(id obj) {
            _pageCount--;
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * err =  obj;
                HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            [self.estimateListView.mj_footer endRefreshing];
        }];
    }
    else
    {
        
        HUDSHOW(@"没有更多了...");
        [self.estimateListView.mj_footer endRefreshing];
    }
    
    
}
#pragma mark - private methods
-(void)writeCommentButton:(UIButton*)button
{
        WriteCommentViewController * writeVC =[[WriteCommentViewController alloc] init];
        writeVC.good_id = self.good_id;
        UINavigationController * navigation =[[UINavigationController alloc] initWithRootViewController:writeVC];
        [self.lcNavigationController pushViewController:navigation];
}


#pragma mark -- tableview delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    CGFloat height =[self.estimateListView   cellHeightForIndexPath:indexPath model:[EstimateModel mj_objectWithKeyValues:array[indexPath.row]] keyPath:@"model" cellClass:[EstimateTableViewCell class] contentViewWidth:kScreenWidth];
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EstimateTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[EstimateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    EstimateModel * model = [EstimateModel mj_objectWithKeyValues:array[indexPath.row]];
    cell.model = model;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendComment];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - setter and getter

-(UITableView *)estimateListView
{
    if (!_estimateListView) {
        _estimateListView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _estimateListView.delegate =self;
        _estimateListView.dataSource =self;
        if([_estimateListView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_estimateListView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_estimateListView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_estimateListView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        _estimateListView.tableFooterView =view;
        _estimateListView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        _estimateListView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    return _estimateListView;
}

-(UIView *)tabView
{
    if(!_tabView)
        
    {
        _tabView  =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        [_tabView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * line  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SINGLE_LINE_WIDTH)];
        [line setBackgroundColor:ShiXianColor];
        [_tabView addSubview:line];
        
        [_tabView addSubview:self.sendButton];
        [_tabView addSubview:self.commeunityTextField];
        
    }
    return _tabView;
}
-(UIButton *)sendButton
{
    if(!_sendButton)
    {
        _sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(kScreenWidth-70, 0, 60, kBottomBarHeight)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:DefaultFontSize(15)];
        [_sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchDown];
    }
    return _sendButton;
}
-(UITextField *)commeunityTextField
{
    if(!_commeunityTextField)
    {
        _commeunityTextField =[[UITextField alloc] initWithFrame:CGRectMake(KLeft,7, kScreenWidth-80, 35)];
        _commeunityTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commeunityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _commeunityTextField.placeholder =@"发表一下您的评论";
        _commeunityTextField.delegate =self;
        [_commeunityTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
        _commeunityTextField.returnKeyType = UIReturnKeySend;
    }
    return _commeunityTextField;
}
- (UIButton *)writeCommentButton
{
    if (!_writeCommentButton) {
        _writeCommentButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _writeCommentButton.frame =CGRectMake(kScreenWidth-54,kScreenHeight-54, 44,44);
        [_writeCommentButton setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
        
        [_writeCommentButton addTarget:self action:@selector(writeCommentButton:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _writeCommentButton;
}

@end

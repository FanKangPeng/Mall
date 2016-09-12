//
//  CommentListViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommentListViewController.h"
#import "EstimateTableViewCell.h"
#import "NoDataView.h"
#import "CommunityTool.h"
#import "CommunityCell.h"
#import "Community_CommentModel.h"
@interface CommentListViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@end

@implementation CommentListViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    if (_tabView) {
        [self getData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"所有评论" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf.commeunityTextView resignFirstResponder];
        double delayInSeconds =[weakSelf.commeunityTextView isFirstResponder] ? 1.0 : 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lcNavigationController popViewController];
        });
    };
    _pageCount=1;
    [self.view addSubview:NavigationView];
    [self.view bringSubviewToFront:NavigationView];
    [self AddObserverForKeyboard];
    [self.view addSubview:self.tabView];
    [self.view bringSubviewToFront:self.tabView];
    
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (_estimateListView) {
        [_estimateListView removeFromSuperview];
        _estimateListView = nil;
    }
}
#pragma mark - server methods
-(void)getData
{
    if (_noDataView.mj_header.isRefreshing) {
       [_noDataView.mj_header endRefreshing];
    }
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [CommunityTool getComment:@"/comment/list" params:@{@"type":@"2",@"id":self.post_id} success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.commentDict = [NSMutableDictionary dictionaryWithDictionary:obj];
      
    } failure:^(id obj) {
        [hud hide: YES];
         [self removeView];
          self.CommentError = obj;
    }];
}
-(void)loadMore
{
    NSNumber * allCount = [[self.commentDict objectForKey:@"paginated"] objectForKey:@"more"];
    if ([allCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _pageCount++;
        NSDictionary * dict=@{@"type":@"2",@"id":self.post_id,@"pagination":@{@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_pageCount],@"count":@"10"}};
        [CommunityTool getCommentMoreDate:@"/comment/list" params:dict success:^(id obj) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.commentDict];
            NSMutableArray * communityArr =[dict objectForKey:@"comment"];
            [communityArr addObjectsFromArray:[obj objectForKey:@"comment"]];
            
            [dict setObject:[obj objectForKey:@"paginated"] forKey:@"paginated"];
            [dict setObject:communityArr forKey:@"comment"];
            self.commentDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            if (self.estimateListView.mj_footer.isRefreshing) {
                [self.estimateListView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            self.LoadMoreError = obj;

        }];
    }
    else
    {
        HUDSHOW(@"没有更多了...");
        if (self.estimateListView.mj_footer.isRefreshing) {
            [self.estimateListView.mj_footer endRefreshing];
        }
    }
    
    
}
-(void)sendComment
{
    _isButtonClicked = NO;
    _commeunityTextView.inputView = nil;
    [_commeunityTextView resignFirstResponder];
    if(_commeunityTextView.text.length<=0)
    {
        HUDSHOW(@"呱唧几句吧亲");
    }
    else
    {
        [CommunityTool addComment:@"/comment/add" params:@{@"type":@"2",@"id":self.post_id,@"reply_id":@"",@"content":_commeunityTextView.text} success:^(id obj) {
            [_commeunityTextView setText:@""];
            HUDSHOW(@"评论成功");
            [self getData];
         
        } failure:^(id obj) {
            self.SendCommentError = obj;
        }];
    }
    
}
#pragma mark - private methods
- (void)faceButtonClick:(UIButton*)button
{
    _isButtonClicked = YES;
    _faceButton.selected=NO;
    
    if ([_commeunityTextView.inputView isEqual:self.faceBoard]) {
        [_commeunityTextView resignFirstResponder];
    }
    else
    {
        
        if (!_isShowKeyBoard) {
            self.faceBoard.inputTextView = _commeunityTextView;
            _commeunityTextView.inputView = self.faceBoard;
            _faceButton.selected = YES;
             [_commeunityTextView becomeFirstResponder];
        }
        else
        {
            [_commeunityTextView resignFirstResponder];
        }
    }
}
#pragma mark --- NSNotification keyboard
-(void)AddObserverForKeyboard
{
    UITapGestureRecognizer * dismissKeyBoardtap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardtapClick:)];
    [self.view addGestureRecognizer:dismissKeyBoardtap];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        NSLog(@"%f",keyboardRect.size.height);
         self.tabView.top = kScreenHeight - kBottomBarHeight -keyboardRect.size.height;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
          self.tabView.top = kScreenHeight-kBottomBarHeight;
    }];
  
  
}
- (void)keyboardDidHide:(NSNotification *)notification {
    _faceButton.selected = NO;
    if (_isButtonClicked) {
        _isButtonClicked = NO;
        if (![_commeunityTextView.inputView isEqual:_faceBoard]) {
            self.faceBoard.inputTextView = _commeunityTextView;
            _commeunityTextView.inputView = self.faceBoard;
            _faceButton.selected = YES;
        }
        else
        {
            _commeunityTextView.inputView = nil;
        }
         [_commeunityTextView becomeFirstResponder];
        _isShowKeyBoard = YES;
    }
    else
        _isShowKeyBoard = NO;
}
-(void)dismissKeyBoardtapClick:(UITapGestureRecognizer*)tap
{
    _isButtonClicked = NO;
    _commeunityTextView.inputView = nil;
    [self.commeunityTextView resignFirstResponder];
   
    
}

#pragma mark - UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    return array.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    CGFloat height =[self.estimateListView  cellHeightForIndexPath:indexPath model:[Community_CommentModel mj_objectWithKeyValues:array[indexPath.section]] keyPath:@"commentModel" cellClass:[CommunityCell class] contentViewWidth:kScreenWidth];
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString * cellIdentifier = @"Cell";
    CommunityCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    Community_CommentModel * model = [Community_CommentModel mj_objectWithKeyValues:array[indexPath.section]];
    cell.commentModel = model;
    cell.CommunityCellBlock =^{
      [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
    };
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        //到点评list
        //  _estimateListBlock();
        
    }
    else
    {
        
    }
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
#pragma mark - UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _isShowKeyBoard  = YES;
    if ([textView.textColor isEqual:FontColor_gary]) {
        textView.text = @"";
        textView.textColor = FontColor_black;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
   
    if (textView.text.length == 0) {
        _commeunityTextView.textColor = FontColor_gary;
        _commeunityTextView .text = @"发表一下您的评论";
    }
}
#pragma mark - FKPTextView
- (void)deleteBackward
{
    NSString *string = nil;
    NSString * inputString = _commeunityTextView.text;
    NSInteger stringLength = _commeunityTextView.text.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    _commeunityTextView.text =  string;

}
#pragma mark - setter and getter
- (void)setSendCommentError:(id)SendCommentError
{
    if([SendCommentError isKindOfClass:[NSError class]])
    {
        NSError * err = SendCommentError;
        
        HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
    }
    else
    {
        
        if ([[SendCommentError objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]||[[SendCommentError objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:LogIn object:nil];
            
        }
        else
        {
            HUDSHOW([SendCommentError objectForKey:@"error_desc"]);
        }
        
    }

}
- (void)setLoadMoreError:(id)LoadMoreError
{
    _pageCount--;
    if ([LoadMoreError isKindOfClass:[NSError class]]) {
        NSError * err =  LoadMoreError;
        HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
    }
    else
    {
        HUDSHOW([LoadMoreError objectForKey:@"error_desc"]);
    }
    if (self.estimateListView.mj_footer.isRefreshing) {
        [self.estimateListView.mj_footer endRefreshing];
    }
}
- (void)setCommentError:(id)CommentError
{
    if ([CommentError isKindOfClass:[NSError class]]) {
        
        NSError * err = CommentError;
        if ([[err.userInfo  objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
            [self.view addSubview:self.noDataView];
            [self.view sendSubviewToBack:self.noDataView];
        }
        else
        {
            self.noreachView.error = CommentError;
            [self.view addSubview:self.noreachView];
            [self.view sendSubviewToBack:self.noreachView];
        }
        
    }
    else
    {
        HUDSHOW([CommentError objectForKey:@"error_desc"]);
    }
    
}
- (void)setCommentDict:(NSMutableDictionary *)commentDict
{
    _commentDict = commentDict;
    NSArray * array =[self.commentDict objectForKey:@"comment"];
    if (array) {
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
    else
    {
        [self.view addSubview:self.noDataView];
        [self.view sendSubviewToBack:self.noDataView];
    }
}
- (NotReachView *)noreachView
{
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] init];
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getData];
        };
    }
    return _noreachView;
}
- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight)];
        _noDataView.CAPION =@"暂无评价";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    }
    return _noDataView;
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
        [_tabView addSubview:self.faceButton];
        [_tabView addSubview:self.sendButton];
        [_tabView addSubview:self.commeunityTextView];
        
    }
    return _tabView;
}
-(UIButton *)sendButton
{
    if(!_sendButton)
    {
        _sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(kScreenWidth-50, 0, 50, kBottomBarHeight)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:DefaultFontSize(15)];
        [_sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchDown];
    }
    return _sendButton;
}
- (FKPTextView *)commeunityTextView
{
    if(!_commeunityTextView)
    {
        _commeunityTextView =[[FKPTextView alloc] initWithFrame:CGRectMake(50,7, kScreenWidth-100, 35)];
        _commeunityTextView.layer.borderColor = FontColor_gary.CGColor;
        _commeunityTextView.layer.borderWidth = SINGLE_LINE_WIDTH;
        _commeunityTextView.layer.cornerRadius = 3;
        _commeunityTextView.layer.masksToBounds = YES;
        _commeunityTextView.delegate = self;
        _commeunityTextView.FkpDeleteDelegate=self;
        _commeunityTextView.text =@"发表一下您的评论";
        _commeunityTextView.delegate =self;
        _commeunityTextView.font = DefaultFontSize(14);
        _commeunityTextView.textColor = FontColor_gary;
        _commeunityTextView.returnKeyType = UIReturnKeySend;
        _isSystemBoardShow = NO;
    }
    return _commeunityTextView;
}
-(UITableView *)estimateListView
{
    if (!_estimateListView) {
        _estimateListView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
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
- (FaceBoard *)faceBoard
{
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
    }
    return _faceBoard;
}
- (UIButton *)faceButton
{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setFrame:CGRectMake(0, 5, 50, 40)];
        [_faceButton setImage:[UIImage imageNamed:@"icon_keyboard_face"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"icon_send_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _faceButton;
}
#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

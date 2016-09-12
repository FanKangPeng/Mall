//
//  HelpNextViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "HelpNextViewController.h"
#import "UserInfoTool.h"
#import "HelpDeatilViewController.h"
@interface HelpNextViewController ()
@property(nonatomic,strong)NotReachView * noreachView;
@end

@implementation HelpNextViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_noreachView ||_listView) {
        [self  getData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
   _setNavigationView =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
   [_setNavigationView initViewWithTitle:self.title andBack:@"icon_back.png" andRightName:@""];
     __WEAK_SELF_YLSLIDE
    _setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:_setNavigationView];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(!_listView)
    {
        [self.view addSubview:self.listView];
    }
    else
    {
        [self.listView.mj_footer endRefreshing];
        [self.listView.mj_header endRefreshing];
        [self.listView reloadData];
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
    }
    
}
-(void)getData
{
    [UserInfoTool userInfo:@"/help/list" params:@{@"id":self.post_id} success:^(id obj) {
      
        [_setNavigationView initViewWithTitle:[obj objectForKey:@"title"] andBack:@"icon_back.png" andRightName:@""];
        self.titleArr = [NSMutableArray arrayWithArray:[obj objectForKey:@"list"]];
        [self initView];
    } failure:^(id obj) {
        [self initFailView:obj];
    }];
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_listView setTableFooterView:view];
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.scrollEnabled =NO;
    }
    return _listView;
}
#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    
    cell.textLabel.text =[self.titleArr[indexPath.row] objectForKey:@"name"];
    cell.textLabel.textColor= FontColor_gary;
    cell.textLabel.font = DefaultFontSize(15);
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
-(void)buttonClick:(UIButton*)button
{
    if(button.selected)
        button.selected=NO;
    else
        button.selected =YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HelpDeatilViewController * nextVC =[[HelpDeatilViewController alloc] init];
      nextVC.title = [self.titleArr[indexPath.row] objectForKey:@"name"];
    nextVC.post_id =[self.titleArr[indexPath.row] objectForKey:@"id"];
    [self.lcNavigationController pushViewController:nextVC];
    
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
@end

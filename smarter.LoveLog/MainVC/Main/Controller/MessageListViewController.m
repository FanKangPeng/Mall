//
//  MessageListViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()
{
    NSMutableArray * titleArr;
    NSMutableArray * contentArr;
}
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView * mainNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [mainNavigationView initViewWithTitle:@"消息中心" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    mainNavigationView.CustomNavigationLeftImageBlock=^{
        //
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:mainNavigationView];
    titleArr =[NSMutableArray array];
    contentArr =[NSMutableArray array];
    
    [titleArr addObject:@"叮当叮当"];
    [contentArr addObject:@"点击查看您与客服的沟通记录"];
    [self.view addSubview:self.listView];
    // Do any additional setup after loading the view.
}
-(void)listReloadData
{
    [_listView reloadData];
    [_listView.mj_header endRefreshing];
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        UIView * view = [UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_listView setTableFooterView:view];
        _listView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(listReloadData)];
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
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
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text =titleArr[indexPath.row];
    cell.textLabel.textColor= FontColor_black;
    
    cell.detailTextLabel.text= contentArr[indexPath.row];
    cell.detailTextLabel.textColor= FontColor_gary;
    
    [cell.imageView setImage:[UIImage imageNamed:@"icon_jingdongdongdong"]];
      

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
    return 66;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:nil];
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

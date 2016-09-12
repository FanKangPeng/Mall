//
//  AboutViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    NSArray * titleArr;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    _setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [_setNavigationView initViewWithTitle:@"关于我们" andBack:@"icon_back.png" andRightName:@""];
     __WEAK_SELF_YLSLIDE
    _setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:_setNavigationView];
    titleArr =@[@"免责声明",@"特别说明",@"用户协议",@"给我反馈",@"送我好评"];
    [self.view addSubview:self.listView];
}
-(UIView *)headView
{
    if (!_headView) {
        _headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        [_headView setBackgroundColor:[UIColor whiteColor]];
        
        [_headView addSubview:self.iconImage];
        _iconImage.sd_layout
        .leftSpaceToView(_headView,_headView.width/2-40)
        .widthIs(80)
        .heightIs(80)
        .topSpaceToView(_headView,30);
        
        [_headView addSubview:self.namelable];
        _namelable.sd_layout
        .leftSpaceToView(_headView,0)
        .rightSpaceToView(_headView,0)
        .topSpaceToView(_iconImage,KLeft)
        .heightIs(15);
        
        [_headView addSubview:self.versionsLabel];
        _versionsLabel.sd_layout
        .leftSpaceToView(_headView,0)
        .rightSpaceToView(_headView,0)
        .topSpaceToView(_namelable,KLeft)
        .heightIs(15);
        
        [_headView addSubview:self.backView];
        _backView.sd_layout
        .leftSpaceToView(_headView,0)
        .rightSpaceToView(_headView,0)
        .bottomSpaceToView(_headView,0)
        .heightIs(10);
        
    }
    return _headView;
}
-(UIView *)backView
{
    if (!_backView) {
        _backView =[UIView new];
        [_backView setBackgroundColor:BackgroundColor];
    }
    return _backView;
}
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _iconImage.image =[UIImage imageNamed:@"Icon"];
    }
    return _iconImage;
}
-(UILabel *)namelable
{
    if (!_namelable) {
        _namelable =[UILabel new];
        _namelable.font = DefaultFontSize(16);
        _namelable.textColor= FontColor_black;
        _namelable.text=@"爱的日志";
        _namelable .textAlignment = NSTextAlignmentCenter;
    }
    return _namelable;
}
-(UILabel *)versionsLabel
{
    if (!_versionsLabel) {
        _versionsLabel =[UILabel new];
        _versionsLabel.font = DefaultFontSize(14);
        _versionsLabel.textColor= FontColor_black;
        _versionsLabel.text=@"v1.0";
        _versionsLabel .textAlignment = NSTextAlignmentCenter;
    }
    return _versionsLabel;
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
        [_listView setTableHeaderView:self.headView];
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
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text =titleArr[indexPath.row];
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

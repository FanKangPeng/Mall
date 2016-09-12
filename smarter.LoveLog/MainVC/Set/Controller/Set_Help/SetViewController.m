//
//  SetViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SetViewController.h"
#import "AdressManagerViewController.h"
#import "LocationViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"
#import "MyKeyChainHelper.h"
#import "AFNetHttp.h"

@interface SetViewController ()
@property (nonatomic ,strong) UIButton *button;
@end

@implementation SetViewController
@synthesize button;
- (void)viewWillAppear:(BOOL)animated
{
    NSString * title = isLogin ? @"退出登录" : @"登录";
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:@"设置" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:setNavigationView];
    
    NSUInteger  cacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString * cacheStr =[NSString stringWithFormat:@"已缓存%.2fM",(CGFloat)cacheSize/1024/1024];
    titleArr=[NSMutableArray arrayWithArray:@[@"清除图片缓存",@"小图模式(省高达70%流量)",@"意见反馈",@"帮助中心",@"客服电话",@"关于我们",@"打赏我们",@"当前版本"]];
    contentArr = [NSMutableArray arrayWithArray:@[cacheStr,@"",@"",@"",@"400-086-0780",@"",@"",@"1.0"]];
    imageArr =[NSMutableArray arrayWithArray:@[@"more",@"",@"more",@"more",@"",@"more",@"more",@""]];
    [self.view setBackgroundColor:BackgroundColor];
    [self.view addSubview:self.listView];
    
    
    button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(20, self.view.frame.size.height-60, kScreenWidth-40, 45);
    [button setBackgroundColor:NavigationBackgroundColor];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font =DefaultFontSize(18);
    button.layer.cornerRadius=5;
    button.layer.masksToBounds =YES;
    [button addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    //获取session 信息 来判断按钮的状态
    // Do any additional setup after loading the view.
}

-(void)loginOut:(UIButton*)button1
{
  if(!isLogin)
  {
      [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];

  }
    else
    {
        __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.color  =[UIColor clearColor];
        hud.mode= MBProgressHUDModeCustomView;
        hud.customView = [[LoadGIF_M alloc] init];
        [hud show:YES];

        [AFNetHttp getData:@"/user/logout" params:nil session:YES success:^(NSDictionary *response) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
            [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
             [hud hide:YES];
            [button1 setTitle:@"登录" forState:UIControlStateNormal];
          
        } failure:^(NSError *error) {
            HUDSHOW(@"请求失败");
               [hud hide:YES];
        }];
    }
    
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 350) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
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
    
    cell.detailTextLabel.text= contentArr[indexPath.row];
    cell.detailTextLabel.textColor= FontColor_lightGary;
    cell.detailTextLabel.font = DefaultFontSize(15);
    NSString * imageName  = imageArr[indexPath.row];
    if(![imageName isEqualToString:@""])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row==1)
    {
        UIButton * button1 =[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(kScreenWidth-60, 13, 45, 23);
        [button1 setBackgroundImage:[UIImage imageNamed:@"set_switch_on"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"set_switch_off"] forState:UIControlStateSelected];
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:button1];
    }

   
    return cell;
}
-(void)buttonClick:(UIButton*)button2
{
    if(button2.selected)
        button2.selected=NO;
    else
        button2.selected =YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //清除缓存
        {
            CustomAlertView * alert =[[CustomAlertView alloc]initWithTitle:@"是否清除图片缓存" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
            alert.delegate =self;
            [alert show];
        }
           
            break;

        case 2:
            //意见反馈
              [self.lcNavigationController pushViewController:[[FeedbackViewController alloc] init]];
            break;
        case 3:
            //帮助反馈
                [self.lcNavigationController pushViewController:[[HelpViewController alloc] init]];
            break;
        case 4:
            //电话
        {
            NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",@"400-086-0780"]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        }
       
            break;
        case 5:
            //关于我们
            [self.lcNavigationController pushViewController:[[AboutViewController alloc] init]];
            break;
        case 6:
            //打赏我们
            break;
     
            
        default:
            break;
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
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[SDImageCache sharedImageCache] clearDisk];
          NSUInteger  cacheSize = [[SDImageCache sharedImageCache] getSize];
        [contentArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"已缓存%.2fM",(CGFloat)cacheSize/1024/1024]];
        [self.listView reloadData];
        
    }
    else
        [customAlertView hide];
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

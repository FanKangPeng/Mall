//
//  RedPacketViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketCell.h"

#import "UserInfoTool.h"
@implementation RedPacketViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_noDataView||_noreachView ||_redList) {
        [self getRedPacketDataWithType];
    }
}
-(void)viewDidLoad
{
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"我的红包" andBack:@"icon_back.png" andRightName:_rightbtnTitle];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    NavigationView.CustomNavigationCustomRightBtnBlock =^(UIButton *rightBtn){
        //完成
        [self userRedPacket];
    };
    [self.view addSubview:NavigationView];
    
    [self.view setBackgroundColor:BackgroundColor];
    type=@"1";
    [self getRedPacketDataWithType];
}
-(void)initTitleView
{
    if(!_titleList)
    {
        [self.view addSubview:self.titleList];
    }
}
-(void)initView
{
    if(!_redList)
    {
        [self.view addSubview:self.redList];
    }
    else
    {
        [self.redList.mj_footer endRefreshing];
        [self.redList.mj_header endRefreshing];
        [self.redList reloadData];
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
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0,kNavigationHeight +  _titleList.height, kScreenWidth, kScreenHeight-kNavigationHeight- _titleList.bottom)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getRedPacketDataWithType];
        };
        [self.view addSubview:_noreachView];
    }
}
-(void)initNodataView
{
    if (!_noDataView) {
    
        _noDataView  =[[NoDataView alloc] initWithFrame:CGRectMake(0,kNavigationHeight +  _titleList.height, kScreenWidth, kScreenHeight-kNavigationHeight- _titleList.bottom)];
        _noDataView.CAPION =@"暂无未用的红包";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRedPacketDataWithType)];
        [self.view addSubview:_noDataView];
    }
}
-(void)getRedPacketDataWithType
{
    [_noDataView.mj_header endRefreshing];
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    
    [UserInfoTool getRedPacketData:@"/user/bonus" params:@{@"type":type} success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.countDict  = [NSDictionary dictionaryWithDictionary:[obj objectForKey:@"count"]];
        self.redPacketList  =[NSMutableArray arrayWithArray: [obj objectForKey:@"list"]];
       
    } failure:^(id obj) {
         [hud hide:YES];
        [self removeView];
        if ([obj isKindOfClass:[NSError class]]) {
            
            NSError * err =obj;
            if ([[err.userInfo objectForKey:@"NSLocalizedDescription"]isEqualToString:@"暂无数据"]) {
                [self initNodataView];
            }
            else
                [self initFailView:obj];
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
              
            }
            [self initFailView:obj];
        }
        
    }];
}

- (void)userRedPacket
{
    if (usedBonusTag <= 0) {
           [self.lcNavigationController popViewController];
    }else
    {
       RedPacketModel *model = self.redPacketList[usedBonusTag - 30000];
        [UserInfoTool userRedPacket:@"/flow/change_bonus" params:@{@"bonus_id":model.id} success:^(id obj) {
            [self.lcNavigationController popViewControllerCompletion:^{
                self.usedRedPacketBlokc ([obj objectForKey:@"data"]);
            }];
        } failure:^(id obj) {
            [self.lcNavigationController popViewController];
        }];
    }
}
-(void)buttonClick:(UIButton*)button
{
    if(button.tag !=_buttonTag)
    {
        UIButton * lastButton =(UIButton*)[self.titleList viewWithTag:_buttonTag];
        lastButton.selected=NO;
        button.selected=YES;
        redLine.frame = CGRectMake(button.frame.origin.x+20, kBottomBarHeight-SINGLE_LINE_WIDTH, kScreenWidth/3-40, SINGLE_LINE_WIDTH);
        if(self.redList)
        {
            [self.redList removeFromSuperview];
            self.redList = nil;
            [self.view addSubview:self.redList];
        }
   
    }
    _buttonTag=button.tag;
    NSUInteger xxx =_buttonTag-99;
    type=[NSString stringWithFormat:@"%ld",(long)xxx];
    
    [self getRedPacketDataWithType];
}
#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.redPacketList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedPacketCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell ==  nil) {
        cell =[[RedPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RedPacketModel * model =self.redPacketList[indexPath.row];
    cell.redPacketModel = model;
    if (_rightbtnTitle.length > 0) {
      if([type isEqualToString:@"1"])
      {
          if ([_bonus_id isEqualToString:model.id]) {
              usedBonusTag = indexPath.row + 30000;
              cell.selectImg.hidden = false;
          }else
              cell.selectImg.hidden = true;
      }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_rightbtnTitle.length > 0) {
        RedPacketCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.imageName isEqualToString:@"redPacket_paper_unusered.jpg"]) {
            [self changeSelectImg];
            
            RedPacketCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectImg.hidden = false;
            usedBonusTag = indexPath.row + 30000;
        }
    }
}
- (void)changeSelectImg
{
    //把cell的selectImag 显示的 全部hide
    if (usedBonusTag > 0) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:usedBonusTag - 30000 inSection:0];
        RedPacketCell * cell = [self.redList cellForRowAtIndexPath:index];
        cell.selectImg.hidden = true;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RedPacketModel * model = [RedPacketModel mj_objectWithKeyValues:self.redPacketList[indexPath.row]];
    model.type = [NSString stringWithFormat:@"%lu",(unsigned long)_buttonTag];
    CGFloat height = [self.redList  cellHeightForIndexPath:indexPath model:model keyPath:@"redPacketModel" cellClass:[RedPacketCell class] contentViewWidth:kScreenWidth];
    return height;
}
- (void)setCountDict:(NSDictionary *)countDict
{
    _countDict = countDict;
    [self initTitleView];
}

- (void)setRedPacketList:(NSMutableArray *)redPacketList
{
    _redPacketList = redPacketList;
    
    for (RedPacketModel *model  in redPacketList) {
        if ([_bonus indexOfObject:model] != NSNotFound) {
            model.type = @"100";
        }else
            model.type = @"101";
    }

    if (redPacketList.count>0) {
        [self initView];
    }
    else
    {
        [self initNodataView];
    }
}

-(UITableView *)redList
{
    if(!_redList)
    {
        _redList =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight+kBottomBarHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
        _redList.delegate =self;
        _redList.dataSource =self;
        [_redList setBackgroundColor:BackgroundColor];
        
        //  self.redList.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.redList.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRedPacketDataWithType)];
        _redList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _redList;
}
//-(void)loadNewData
//{
//    [self.redList.mj_footer endRefreshing];
//}
-(UIView *)titleList
{
    if(!_titleList)
    {
        _titleList =[[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kBottomBarHeight+SINGLE_LINE_WIDTH)];
        [_titleList setBackgroundColor:[UIColor whiteColor]];
        NSString * str1 =[NSString stringWithFormat:@"未使用%@",[self.countDict objectForKey:@"unused"]];
        NSString * str2 =[NSString stringWithFormat:@"已使用%@",[self.countDict objectForKey:@"used"]];
        NSString * str3 =[NSString stringWithFormat:@"已过期%@",[self.countDict objectForKey:@"overdue"]];
        NSArray * labelTexts =@[str1,str2,str3];
        for (int i = 0; i<3; i++)
        {
            
            
            UIButton * button  =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(kScreenWidth/3 * i,0, kScreenWidth/3,kBottomBarHeight);
            [button setTitleColor:FontColor_gary forState:UIControlStateNormal];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateHighlighted];
            [button setTitleColor:NavigationBackgroundColor forState:UIControlStateSelected];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button.titleLabel setFont:DefaultFontSize(15)];
            [button setTitle:[NSString stringWithFormat:@"%@",labelTexts[i]] forState:UIControlStateNormal];
            button.tag = 100+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            [_titleList addSubview:button];
            
            if(i==0)
            {
                redLine =[[UILabel alloc] initWithFrame:CGRectMake(20, kBottomBarHeight-SINGLE_LINE_WIDTH, kScreenWidth/3-40, SINGLE_LINE_WIDTH)];
                [redLine setBackgroundColor:NavigationBackgroundColor];
                [self.titleList addSubview:redLine];
                
                _buttonTag = button.tag;
                button.selected =YES;
            }
            
            
            UILabel * shuxian  =[[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width * i -SINGLE_LINE_WIDTH, _titleList.frame.size.height/2-10, SINGLE_LINE_WIDTH, 20)];
            [shuxian setBackgroundColor:ShiXianColor];
            [_titleList addSubview:shuxian];
            
        }
        
        UILabel * hengline =[[UILabel alloc] initWithFrame:CGRectMake(0, kBottomBarHeight, kScreenWidth, SINGLE_LINE_WIDTH)];
        [hengline setBackgroundColor:ShiXianColor];
        [_titleList addSubview:hengline];
    }
    return _titleList;
}
@end


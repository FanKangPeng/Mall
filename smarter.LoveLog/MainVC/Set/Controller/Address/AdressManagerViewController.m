//
//  AdressManagerViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AdressManagerViewController.h"
#import "AddAdressViewController.h"
#import "AddressTableViewCell.h"
#import "AddressTool.h"
@interface AdressManagerViewController ()
@property(nonatomic,strong) NotReachView * noreachView;
@property(nonatomic,strong)NoDataView * noDataView;
@end

@implementation AdressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     __WEAK_SELF_YLSLIDE
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"地址管理" andBack:@"icon_back.png" andRightName:@"添加"];
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    NavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //添加
        [self addOrEditWithIndex:@"10000"];
    };

    [self.view addSubview:NavigationView];
    
   
    
    [self getAddressData];
    
    // Do any additional setup after loading the view.
}

-(void)initView
{
    
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(!_addressList)
    {
        [self.view addSubview:self.addressList];
        [self.view sendSubviewToBack:self.addressList];
    }
    else
    {
        [self.addressList.mj_header endRefreshing];
        [self.addressList reloadData];
    }
}
-(void)initNodataView
{
    if (!_noDataView) {
        
        _noDataView  =[[NoDataView alloc] init];
        _noDataView.CAPION =@"暂未设置收货地址";
        _noDataView.tag =111;
        _noDataView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAddressData)];
        [self.view addSubview:_noDataView];

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
  
    __WEAK_SELF_YLSLIDE
    _noreachView  =[[NotReachView alloc] init];
    _noreachView.error = error;
    _noreachView.ReloadButtonBlock=^{
        [weakSelf getAddressData];
    };
    [self.view addSubview:_noreachView];
    
}
-(void)getAddressData
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView =[[LoadGIF_M alloc] init];
    [hud show:YES];
    [AddressTool getAddressList:@"/address/list" params:nil success:^(id obj) {
        [hud hide:YES];
        [self removeView];
        self.contentArr =[NSMutableArray arrayWithArray:obj];
        [self initView];
        
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
//设置默认地址
-(void)setDefauleAddressWithID:(NSString*)Addressid
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [AddressTool setDefaultAddress:@"/address/set_default" params:@{@"id":Addressid} success:^(id obj) {
        [hud hide:YES];
        HUDSHOW(@"设置成功");
        [self getAddressData];
    } failure:^(id obj) {
        [hud hide:YES];
        if (obj) {
            HUDSHOW([obj objectForKey:@"error_desc"]);
        }
        else
        {
            NSError * err = obj;
            HUDSHOW( [err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
    }];
}
//删除地址
-(void)deleteAddressWithID:(NSString*)Addressid
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [AddressTool setDefaultAddress:@"/address/delete" params:@{@"id":Addressid} success:^(id obj) {
        [hud hide:YES];
        HUDSHOW(@"删除成功");
        [self getAddressData];
    } failure:^(id obj) {
        [hud hide:YES];
        if (obj) {
            HUDSHOW([obj objectForKey:@"error_desc"]);
        }
        else
        {
            NSError * err = obj;
            HUDSHOW( [err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
    }];
}
-(UITableView *)addressList
{
    if(!_addressList)
    {
        _addressList =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth,kScreenHeight- kNavigationHeight) style:UITableViewStylePlain];
        _addressList.delegate=self;
        _addressList.dataSource=self;
        [_addressList setBackgroundColor:BackgroundColor];
        _addressList.separatorStyle = UITableViewCellSeparatorStyleNone;

      
        self.addressList.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAddressData)];
    }
    return _addressList;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contentArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height =[self.addressList cellHeightForIndexPath:indexPath model:self.contentArr[indexPath.section]  keyPath:@"addressModel" cellClass:[AddressTableViewCell class] contentViewWidth:kScreenWidth];
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __WEAK_SELF_YLSLIDE
    AddressTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell  =[[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.tag = indexPath.section;
    AddressModel * model = self.contentArr[indexPath.section];
    cell.addressModel = model;
    
    cell.addressCellBlockDefault = ^(NSString * index) {
        [weakSelf setDefauleAddressWithID:index];
    };
    cell.addressCellBlockDelete=^(NSString * index) {
        
        CustomAlertView * alert =[[CustomAlertView alloc] initWithTitle:@"是否删除该收货地址" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        alert.tag = [index integerValue];
        alert.delegate =self;
        [alert show];
    };
    
    cell.addressCellBlockEdit=^(NSString * index) {
        
        [self addOrEditWithIndex:index];
        
    };
 
    if (_cellCanSeleted) {
        if ([_usedModedID isEqualToString:model.id]) {
             cell.selectImg.hidden = false;
        
        }else
             cell.selectImg.hidden = true;
    }
    

    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
 
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellCanSeleted) {
        
        [self.lcNavigationController popViewControllerCompletion:^{
            AddressModel * model = self.contentArr[indexPath.section];
              _AdressBlock(model.id);
        }];
    }
}
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
        if(buttonIndex ==1)
        {
            //删除地址  然后从服务器获取地址 刷新列表
            [self deleteAddressWithID:[NSString stringWithFormat:@"%ld",(long)customAlertView.tag]];
        }
        else
            [customAlertView hide];
    
}

-(void)addOrEditWithIndex:(NSString *)index
{
    AddAdressViewController * addressVC =[[AddAdressViewController alloc] init];
    
    addressVC.saveTxt = @"保存";
    
    if(![index isEqualToString:@"10000"])
    {
        addressVC.addressModel = self.contentArr[[index intValue]];
        addressVC.titleStr =@"修改收货地址";
    }
    else
         addressVC.titleStr =@"添加收货地址";
    
    
    __WEAK_SELF_YLSLIDE
    addressVC.addAdressBlock = ^(NSString * adressID){
        [weakSelf getAddressData];
    };
    [self.lcNavigationController pushViewController:addressVC];
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

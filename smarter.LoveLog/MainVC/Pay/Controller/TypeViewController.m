//
//  TypeViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "TypeViewController.h"
#import "TypeTableViewCell.h"
#import "ExpressageModel.h"
#import "PaymentMethod.h"
@interface TypeViewController ()

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView *NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"选择支付配送方式" andBack:@"icon_back.png" andRightName:@"" ];
    [self.view addSubview:NavigationView];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        [weakSelf.lcNavigationController popViewController];
        
    };

    // Do any additional setup after loading the view.
}
- (void)sureBtnClick:(UIButton *)sender
{
    [self.lcNavigationController popViewControllerCompletion:^{
        self.TypeVCBlock(selectedData);
    }];
}
#pragma mark -- setter and getter
- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    //设置默认数据
    NSArray * payList = [dataDict objectForKey:@"payList"];
    NSArray * expressList = [dataDict objectForKey:@"expressList"];
    
    selectedData = [NSMutableDictionary  dictionary];
    
    ExpressageModel * model = [expressList firstObject];
    PaymentMethod * payModel = [payList firstObject];
    [selectedData setObject:model.shipping_fee forKey:@"yunfei"];
    [selectedData setObject:payModel.id forKey:@"default_pay_id"];
    [selectedData setObject:payModel.name forKey:@"default_pay_name"];
     [selectedData setObject:model.shipping_id forKey:@"default_shipping_id"];
     [selectedData setObject:model.shipping_name forKey:@"default_shipping_name"];
   [selectedData setObject:model.free_money forKey:@"free_money"];
    //设置contentArr的内容
    NSMutableArray * payArr = [NSMutableArray array];
    for (PaymentMethod *  PaymentMethod  in payList) {
        [payArr addObject:PaymentMethod.desc];
    }
    NSMutableArray * expressArr = [NSMutableArray array];
    for (ExpressageModel *  ExpressageModel  in expressList) {
        [expressArr addObject:ExpressageModel.shipping_desc];
    }
    contentArr = @[payArr,expressArr];
    
    [self.view addSubview:self.listView];
    [self.view sendSubviewToBack:self.listView];
    [self.view addSubview:self.sureBtn];
    [self.view bringSubviewToFront:self.sureBtn];
}
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) style:UITableViewStyleGrouped];
        _listView.dataSource = self;
        _listView.delegate =self;
        UIView * view = [UIView new];[view setBackgroundColor:[UIColor clearColor]]; _listView.tableFooterView = view;
    }
    return _listView;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn .frame = CGRectMake(kScreenWidth/6, kScreenHeight - 64, kScreenWidth/3*2, 40);
        _sureBtn .layer.cornerRadius = 5;
        [_sureBtn setBackgroundColor:NavigationBackgroundColor];
        [_sureBtn setTitle:@"确定" forState:0];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn.titleLabel setFont:DefaultFontSize(14)];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
#pragma mark --UITableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        if (cell == nil) {
            cell = [[TypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TypeTableViewCell"];
        }
        if (indexPath.section == 0) {
            cell.dataDict = @{@"icon":[UIImage imageNamed:@"wait_money_icon"],@"title":@"支付方式",@"list":[_dataDict objectForKey:@"payList"]};
        }
        if (indexPath.section == 1) {
            cell.dataDict = @{@"icon":[UIImage imageNamed:@"wait_product_icon"],@"title":@"配送方式",@"list":[_dataDict objectForKey:@"expressList"]};
        }
        cell.tag = indexPath.section;
        
        cell.cellBlock = ^(NSInteger CellTag, NSInteger btnTag ,NSString * btnTitle){
            //1:更改页面内容
            NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:CellTag];
            UITableViewCell * tableViewCell = [tableView cellForRowAtIndexPath:index];
            tableViewCell.textLabel.text = contentArr[CellTag][btnTag];
            //2:更改selectedArr内容
            if (CellTag == 0) {
                NSArray * arr = [_dataDict objectForKey:@"payList"];
                PaymentMethod * payModel = arr[btnTag];
                [selectedData setObject:payModel.id forKey:@"default_pay_id"];
                [selectedData setObject:payModel.name forKey:@"default_pay_name"];
            }else
            {
                NSArray * arr = [_dataDict objectForKey:@"expressList"];
                ExpressageModel * model = arr[btnTag];
                [selectedData setObject:model.shipping_fee forKey:@"yunfei"];
                [selectedData setObject:model.shipping_id forKey:@"default_shipping_id"];
                [selectedData setObject:model.shipping_name forKey:@"default_shipping_name"];
                [selectedData setObject:model.free_money forKey:@"free_money"];
            }
        };
        return cell;
    }
    else
    {
        UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (tableViewCell == nil) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        tableViewCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        tableViewCell.textLabel.font = DefaultFontSize(14);
        tableViewCell.textLabel.text = contentArr[indexPath.section][0];
        return tableViewCell;
    }
    
    return nil;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 90;
    }
    else
        return 40;
}
@end

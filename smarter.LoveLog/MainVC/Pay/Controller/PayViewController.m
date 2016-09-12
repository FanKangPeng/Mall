//
//  PayViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "PayViewController.h"
#import "WXApiManager.h"
#import "umpayManager.h"
#import "AlipayManager.h"
#import "PayTools.h"
@interface PayViewController ()

@end
static NSString *oid  = @"";
@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView *NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"支付订单" andBack:@"icon_back.png" andRightName:@"" ];
    [self.view addSubview:NavigationView];
    NavigationView.CustomNavigationLeftImageBlock=^{
        CustomAlertView * alert =[[CustomAlertView alloc]initWithTitle:@"确认要放弃付款" message:@"下单后2小时订单将被取消，请尽快完成支付" cancelButtonTitle:@"放弃付款" otherButtonTitles:@"继续支付"];
        alert.delegate =self;
        [alert show];
       
    };
    _titleArr=@[@"微信支付",@"支付宝支付",@"银联支付"];
    _images = @[[UIImage imageNamed:@"icon_wechat"],[UIImage imageNamed:@"icon_alipay"],[UIImage imageNamed:@"icon_unionpay"]];
    paytype=0;
    [self.view addSubview:self.listView];
    //支付宝支付结果通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailure:) name:@"payfailure" object:nil];
    // Do any additional setup after loading the view.
}
- (void)paySuccess:(NSNotification *)ddd
{
    [PayViewController payStatus];
}
- (void)payfailure:(NSNotification *)ddd
{
    [PayViewController showPayResult:@"支付失败"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }else
        return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if (indexPath.row == 0) {
        cell.textLabel.font = DefaultFontSize(16);
        cell.textLabel.text = @"请选择支付方式";
    }else
    {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(KLeft, KLeft, 30, 30)];
        imgV.image = _images[indexPath.row-1];
        
        [cell.contentView addSubview:imgV];
        UILabel * txt = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 200, 20)];
        txt.font =  DefaultFontSize(16);
        txt.text = _titleArr[indexPath.row-1];
        [cell.contentView addSubview:txt];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 1:
            [self bizPay];
            break;
        case 2:
            [self alipay];
            break;
        case 3:
            [self umpay];
            break;
            
        default:
            break;
    }

}
#pragma mark pay
- (void)payMetnhod:(NSString*)type success:(CallBack)success failure:(CallBack)failure
{
    [PayTools paywithUrl:@"/payment" params:@{@"code":type,@"oid":[_orderData objectForKey:@"order_id"]} success:^(id obj) {
        success(obj);
    } failure:^(id obj) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
//微信支付
- (void)bizPay {
    [self payMetnhod:@"wechat" success:^(id obj) {
        [self startWechat:obj];
    } failure:^(id obj) {
        
    }];
   
}
- (void)startWechat:(id)obj
{
    [WXApiManager startWeChatPay:nil callBlcok:^(id obj) {
        FLog(@"%@",obj);
    }];
}
//支付宝支付
-(void)alipay
{
    [self payMetnhod:@"alipay" success:^(id obj) {
        [self startAlipay:obj];
    } failure:^(id obj) {
        
    }];
}
- (void)startAlipay:(id)obj
{
    [AlipayManager startAliPay:obj success:^(id obj) {
        
    } failure:^(id obj) {
        
    }];
}
//银联支付
- (void)umpay
{
    [self payMetnhod:@"upop" success:^(id obj) {
        [self startumpay:obj];
    } failure:^(id obj) {
        nil;
    }];
    
}
- (void)startumpay:(id)obj
{
     [umpayManager startPayWithTn:[obj objectForKey:@"tn"] schemeStr:@"UPPayLoveLog" model:@"01" viewController:self];
}
//验证支付结果
+ (void)payStatus
{
    [PayTools paystatuswithUrl:@"/pay/status" params:@{@"oid":oid} success:^(id obj) {
        FLog(@"支付验证结果:%@",[obj objectForKey:@"pay_msg"]);
        CustomAlertView * alert = [[CustomAlertView alloc] initWithTitle:@"支付结果" message:[obj objectForKey:@"pay_msg"] cancelButtonTitle:@"" otherButtonTitles:@"确定"];
        [alert show];
    } failure:^(id obj) {
        HUDSHOW(@"加载失败");
    }];
}
+ (BOOL)verify:(NSString *)sign
{
    return false;
}
+ (void)showPayResult:(NSString *)result
{
    CustomAlertView * alert = [[CustomAlertView alloc] initWithTitle:@"支付结果" message:result cancelButtonTitle:@"" otherButtonTitles:@"确定"];
    [alert show];
}
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //放弃付款  到订单
         [self.lcNavigationController popToRootViewController];
    }
    else
    {
        [customAlertView hide];
    }
}
#pragma mark - setter and getter
- (void)setOrderData:(NSDictionary *)orderData
{
    _orderData = orderData;
    oid = [orderData objectForKey:@"order_id"];
}
-(PayHeadView *)tableViewHeadView
{
    if(!_tableViewHeadView)
    {
        _tableViewHeadView =[[PayHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
        [_tableViewHeadView setBackgroundColor:[UIColor whiteColor]];
       _tableViewHeadView.data = @{@"valid_time":[_orderData objectForKey:@"valid_time"],@"orderNum":[_orderData objectForKey:@"order_sn"],@"orderMoney":[_orderData objectForKey:@"order_amount_formated"]};
    }
    return _tableViewHeadView;
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _listView.delegate=self;
        _listView.dataSource =self;
        _listView.tableHeaderView =self.tableViewHeadView;
        UIView * view = [UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_listView setTableFooterView:view];
    }
    return _listView;
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

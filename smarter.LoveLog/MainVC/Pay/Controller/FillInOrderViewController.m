//
//  FillInOrderViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "FillInOrderViewController.h"
#import "PayViewController.h"
#import "SumTableViewCell.h"
#import "DistributionTableViewCell.h"
#import "GoodDeatilTableViewCell.h"
#import "OrderAddressTableViewCell.h"
#import "MessageTableViewCell.h"
#import "AdressManagerViewController.h"
#import "AddAdressViewController.h"
#import "OrderTools.h"
#import "MaskDetailViewController.h"
#import "ShoppingModel.h"
#import "TypeViewController.h"
#import "InvoiceTableViewCell.h" 
#import "BalanceofAccounTableViewCell.h"
#import "IntegralofAccountTableViewCell.h"

#import "RedPacketViewController.h"
@interface FillInOrderViewController ()

@end

@implementation FillInOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationView *NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"填写订单" andBack:@"icon_back.png" andRightName:@"" ];
    [self.view addSubview:NavigationView];

    NavigationView.CustomNavigationLeftImageBlock=^{
        [self tapClick];
        
        if (isLogin) {
            CustomAlertView * alert =[[CustomAlertView alloc] initWithTitle:@"便宜不等人，请三思而行~" message:@"" cancelButtonTitle:@"我再想想" otherButtonTitles:@"去意已决"];
            alert.delegate =self;
            [alert show];
        }
    };
    
    invoiceStr = @"不开发票";
    usedIntegral = @"0";
    balance = @"0";
    postscript =@"";
    [self getOrderDate];
    
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)tapClick
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
    if ([firstResponderView isKindOfClass:[UITextField class]]) {
        [firstResponderView resignFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self tapClick];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  键盘show
 *
 *  @param aNotification NSNotification
 */
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect viewRect=[firstResponderView convertRect: firstResponderView.bounds toView:window];

    
    CGFloat bottom = viewRect.origin.y + viewRect.size.height;

    
    CGFloat keyboardTop = kScreenHeight - keyboardRect.size.height - 60 ;
    if(bottom  > keyboardTop)
    {
        [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
            scrollHeight += bottom - keyboardTop;
            self.view .top  -= 200;
           // self.listView.contentOffset = CGPointMake(0, self.listView.contentOffset.y + bottom - keyboardTop);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
}

/**
 *  键盘hide
 *
 *  @param aNotification NSNotification
 */
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(self.listView.contentOffset.y>0)
    {
        [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
             self.listView.contentOffset = CGPointMake(0, self.listView.contentOffset.y-scrollHeight);
        } completion:^(BOOL finished) {
            scrollHeight = 0;
        }];
    }
}

/**
 *  计算优惠金额
 *
 *  @return 钱数
 */
- (CGFloat)youhuimoney
{
    return 0;
}
/**
 *  计算总价
 */
- (CGFloat)jisuanzongjia
{
    //1:商品金额 2：运费 3：折扣 4：包装费 5：贺卡费 6：账户余额 7：积分兑换 8：红包
    CGFloat zongjia = 0 ;
    for (NSDictionary * dict in moneyInfoArr) {
        NSString * value = [dict.allValues firstObject];
        NSString * suanfa;
        if ([value hasPrefix:@"-"]) {
            suanfa = @"-";
        }
        else {
            suanfa = @"+";
        }
        value = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
         value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
         value = [value stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        FLog(@"value ==%@",value);
        if ([suanfa isEqualToString:@"-"]) {
            zongjia -= [value floatValue];
        }else
            zongjia += [value floatValue];
    }
    if (zongjia < 0) {
        zongjia = 0.00;
    }
    _tabView.price = zongjia;
    return zongjia;
}
/**
 *  刷新金额cell的数据
 */

- (void)reloadSumCell
{
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:5];
    SumTableViewCell *cell2 = [self.listView cellForRowAtIndexPath:indexPath2];
    cell2.sumArr = moneyInfoArr;
    [self jisuanzongjia];
    //刷新指定cell高度
    [self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil]  withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  获取收货地址和对应的配送方式
 */
- (void)getAddressAndExpressListByAdressID:(NSString * ) adressId
{
    [OrderTools getConsigneeInfowithUrl:@"/flow/change_consignee" params:@{@"addr_id":adressId} success:^(id obj) {
         NSDictionary * data = [NSDictionary dictionaryWithDictionary:obj];
        
        //1:处理地址
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
        OrderAddressTableViewCell *addressCell = [self.listView cellForRowAtIndexPath:indexPath1];
      
        _fillinOrderModel.addressModel =  [data objectForKey:@"consignee"];
          addressCell.addressModel =  _fillinOrderModel.addressModel;
        //2:处理配送
        _expressList = [data objectForKey:@"shipping_list"];
        //调整运费 把支付配送的方式调整为为选择
        //1:更改支付配送界面
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:2];
        DistributionTableViewCell *cell1 = [self.listView  cellForRowAtIndexPath:indexPath2];
        [defaultDistributionDict setObject:@"0" forKey:@"default_shipping_id"];
        [defaultDistributionDict setObject:@"未选择" forKey:@"default_shipping_name"];
        cell1.dict = defaultDistributionDict;
        
        FLog(@"%@",obj);
        
        
    } failure:^(id obj) {
        HUDSHOW(@"加载失败");
    }];
}
#pragma mark -- network 
- (void)getOrderDate
{
    [OrderTools getOrerInfowithUrl:@"/flow/checkout" params:nil success:^(id obj) {
        self.fillinOrderModel  = obj;
    } failure:^(id obj) {
        self.err = obj;
    }];
}
/**
 *  兑换积分
 *
 *  @param integral 积分
 */
- (void)integral:(NSString*)integral CallBack:(CallBack)CallBack
{
    [OrderTools ExchangeIntegralwithUrl:@"/flow/change_integral" params:@{@"integral":integral} success:^(id obj) {
        usedIntegral = integral;
        CallBack(obj);
    } failure:^(id obj) {
        nil;
    }];
    
   
}
/**
 *  提交订单按钮点击事件
 */
- (void)updataOrderDataBtnClick
{
    BOOL result = true;NSString * showStr;
    if ([[defaultDistributionDict objectForKey:@"default_shipping_name"] isEqualToString:@"未选择"]) {
        result = false;
        showStr = @"请选择配送方式";
     }
    if ([[defaultDistributionDict objectForKey:@"default_pay_name"] isEqualToString:@"未选择"]) {
        result = false;
        showStr = @"请选择支付方式";
    }
    
    if (result) {
        [self updataOrderData:^(id obj) {
            //跳转到支付页面  参数为支付所用信息
            PayViewController * payVC =[[PayViewController alloc] init];
            payVC.orderData = [obj objectForKey:@"data"];
            [self.lcNavigationController pushViewController:payVC];
        }];
    }else
         HUDVIEW(showStr, self.view);
        
}
/**
 *  提交订单信息到服务器
 */
- (void)updataOrderData:(CallBack)callBack
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //地址ID
    [dict setObject:_fillinOrderModel.addressModel.id forKey:@"address_id"];
    //支付方式ID
    [dict setObject:[defaultDistributionDict objectForKey:@"default_pay_id"] forKey:@"pay_type"];
    //配送方式ID
    [dict setObject:[defaultDistributionDict objectForKey:@"default_shipping_id"] forKey:@"shipping_id"];
    //使用红包ID
    [dict setObject:[defaultBonusDict objectForKey:@"bonus"] forKey:@"use_bonus"];
    //使用积分数量
    [dict setObject:usedIntegral forKey:@"use_integral"];
    //留言
    [dict setObject:postscript forKey:@"postscript"];
    //发票ID
    [dict setObject:@"0" forKey:@"inv_type"];
    //发票内容
    [dict setObject:@"" forKey:@"inv_content"];
    //发票类型
    [dict setObject:@"" forKey:@"inv_payee"];
    //余额
    [dict setObject:balance forKey:@"use_surplus"];
    FLog(@"orderData == %@",dict);
    [OrderTools  pushOrderDatawithUrl:@"/flow/done" params:dict success:^(id obj) {
        callBack(obj);
    } failure:^(id obj) {
         HUDSHOW([obj objectForKey:@"error_desc"]);
    }];
}
#pragma mark -- UITableView delegate and datesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section ==1 ) {
        return _fillinOrderModel.shopArr.count;
    }else if (section ==3)
        return 3;
    else
        return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            OrderAddressTableViewCell * OrderAddressCell =[tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
            if(OrderAddressCell == nil)
            {
                OrderAddressCell = [[OrderAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderAddressCell"];
            }
            OrderAddressCell.addressModel =_fillinOrderModel.addressModel;
            return OrderAddressCell;
        }
            break;
        case 1:
        {
                GoodDeatilTableViewCell * goodCell =[tableView dequeueReusableCellWithIdentifier:@"goodCell"];
                if(goodCell == nil)
                {
                    goodCell = [[GoodDeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodCell"];
                }
                goodCell.shopModel=_fillinOrderModel.shopArr[indexPath.row];
                
                return goodCell;
          
        }
            break;
        case 2:
        {
            DistributionTableViewCell * distriCell =[tableView dequeueReusableCellWithIdentifier:@"distriCell"];
            if(distriCell == nil)
            {
                distriCell = [[DistributionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"distriCell"];
            }
            
            distriCell.dict = defaultDistributionDict;
            return distriCell;

        }
            
            break;
        case 4:
        {
            MessageTableViewCell * messageCell =[tableView dequeueReusableCellWithIdentifier:@"messageCell"];
            if(messageCell == nil)
            {
                messageCell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
            }
            messageCell.messageBlock = ^(NSString *textField_text){
                postscript = textField_text;
            };
            return messageCell;
        }

            break;
        case 3:
        {
            switch (indexPath.row) {
//                case 0:
//                {
//                    InvoiceTableViewCell * InvoiceCell =[tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
//                    if(InvoiceCell == nil)
//                    {
//                        InvoiceCell = [[InvoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvoiceCell"];
//                    }
//                    if ([[[_fillinOrderModel.total objectForKey:@"tax_formated"] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] floatValue] > 0) {
//                        InvoiceCell.distributionLb.text = invoiceStr;
//                        InvoiceCell.userInteractionEnabled = YES;
//                        InvoiceCell.isShowMoreImg = YES;
//                    }
//                    else
//                    {
//                        InvoiceCell.distributionLb.text = @"该产品不能开发票";
//                        InvoiceCell.userInteractionEnabled = NO;
//                        InvoiceCell.isShowMoreImg = NO;
//                    }
//                    return InvoiceCell;
//                }
//                    break;
                case 0:
                {
                    BalanceofAccounTableViewCell * BalanceofAccounCell =[tableView dequeueReusableCellWithIdentifier:@"BalanceofAccounCell"];
                    if(BalanceofAccounCell == nil)
                    {
                        BalanceofAccounCell = [[BalanceofAccounTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BalanceofAccounCell"];
                    }
                    BalanceofAccounCell.balance = [[_fillinOrderModel.total objectForKey:@"surplus_formated"] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                    if ([BalanceofAccounCell.balance floatValue] > 0) {
                        NSString * balanceString = BalanceofAccounCell.balance;
                        CGFloat jiage = [self jisuanzongjia];
                        if (jiage <= [balanceString floatValue]) {
                            balanceString = [NSString stringWithFormat:@"%.2f",jiage];
                        }
                        
                        balance = balanceString ;
                        
                        NSDictionary * ddd = @{@"账户余额":[NSString stringWithFormat:@"-￥%@",balance]};
                        [self moneyInfoArrAddObject:ddd];
                    }
                    BalanceofAccounCell.UsedBalanceBlock = ^(NSDictionary * data){
                        NSString * balanceString = [data objectForKey:@"账户余额"];
                        balanceString = [balanceString stringByReplacingOccurrencesOfString:@"-" withString:@""];
                         balanceString = [balanceString stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                      
                        CGFloat jiage = [self jisuanzongjia];
                        if (jiage <= [balanceString floatValue]) {
                            balanceString = [NSString stringWithFormat:@"%.2f",jiage];
                        }
                        
                        balance = balanceString ;
                        
                        NSDictionary * ddd = @{@"账户余额":[NSString stringWithFormat:@"-￥%@",balance]};
                        [self moneyInfoArrAddObject:ddd];
                    };
                    BalanceofAccounCell.UnUsedBalanceBlock = ^(){
                        [self moneyInfoArrRemoveObject:@"账户余额"];
                    };
                    return BalanceofAccounCell;
                }
                    break;
                case 1:
                {
                    IntegralofAccountTableViewCell * IntegralofAccountCell =[tableView dequeueReusableCellWithIdentifier:@"IntegralofAccountCell"];
                    if(IntegralofAccountCell == nil)
                    {
                        IntegralofAccountCell = [[IntegralofAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntegralofAccountCell"];
                    }
                    IntegralofAccountCell.integralDict = @{@"user_integral":_fillinOrderModel.user_integral,@"order_max_integral":_fillinOrderModel.order_max_integral};
                    __weak IntegralofAccountTableViewCell * integralCell = IntegralofAccountCell;
                    IntegralofAccountCell.IntegralBlock = ^(NSString *integarl){
                     [self integral:integarl CallBack:^(id obj) {
                         integralCell.result = obj;
                     }];
                    };
                    IntegralofAccountCell.UsedIntegralBlock  = ^(NSDictionary * data){
                        [self moneyInfoArrAddObject:data];
                    };
                    IntegralofAccountCell.UnUsedIntegralBlock = ^(){
                        [self moneyInfoArrRemoveObject:@"积分折扣"];
                    };
                    return IntegralofAccountCell;
                }
                    break;
                case 2:
                {
                    RedPacketofAccountTableViewCell * RedPacketofAccountCell =[tableView dequeueReusableCellWithIdentifier:@"RedPacketofAccountCell"];
                    if(RedPacketofAccountCell == nil)
                    {
                        RedPacketofAccountCell = [[RedPacketofAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RedPacketofAccountCell"];
                    }
                    NSString *sss =[_fillinOrderModel.total objectForKey:@"bonus_formated"];
                    //红包ID
                    NSString * ssss =_fillinOrderModel.default_bonus_id;
                    
                    defaultBonusDict = @{@"bonusStr":sss, @"bonus":ssss,@"bonusCount":[NSString stringWithFormat:@"%lu",(unsigned long)_fillinOrderModel.bonus.count]};
                    RedPacketofAccountCell.bonusDict = defaultBonusDict;
                    RedPacketofAccountCell.RedPacketofAccountDelegate = self;
                    return RedPacketofAccountCell;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            SumTableViewCell * sumCell =[tableView dequeueReusableCellWithIdentifier:@"SumTableViewCell"];
            if(sumCell == nil)
            {
                sumCell = [[SumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SumTableViewCell"];
            }
           
       
            sumCell.sumArr = moneyInfoArr;
            
            return sumCell;
        }
            break;
            
        default:
            break;
    }
 
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
        {
            return 80;
        }
            break;
        case 1:
        {
            return 80;
        }
            break;
        case 2:
        {
            return 60;
        }
            break;
            
        case 4:
        {
            
            return 50;
        }
            break;
        case 3:
        {
            return 44;
        }
            break;
        case 5:
        {
            return  [self.listView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView];
        }
            break;
            
            
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapClick];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //地址
    if(indexPath.section==0)
    {
        if (isLogin) {
            if(_fillinOrderModel.addressModel.consignee)
            {
                AdressManagerViewController * adress = [[AdressManagerViewController alloc] init];
                adress.cellCanSeleted = YES;
                //地址ID
                
                adress.usedModedID =  _fillinOrderModel.addressModel.id;
                adress.AdressBlock = ^(NSString * adressID){
                    [self getAddressAndExpressListByAdressID:adressID];
                };
                [self.lcNavigationController pushViewController:adress];
            }
            else
            {
                AddAdressViewController * addadress = [[AddAdressViewController alloc] init];
                addadress.titleStr =@"添加收货地址";
                addadress.saveTxt =  @"保存并使用";
                addadress.addAdressBlock  = ^(NSString * adressID){
                   [self getAddressAndExpressListByAdressID:adressID];
                };
                [self.lcNavigationController pushViewController:addadress];
            }
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        
    }
    
    if (indexPath.section == 1)
    {
       
            MaskDetailViewController *detailV  = [[MaskDetailViewController alloc] init];
            ShoppingModel *model =  _fillinOrderModel.shopArr[indexPath.row];
            detailV.good_id = model.goods_id;
            
            //        GoodListViewController * goodlist =[[GoodListViewController alloc] init];
            //        goodlist.shoppingArray =self.shoppingArray;
            
            [self.lcNavigationController pushViewController:detailV];
        
    }
    
    if (indexPath.section ==2) {
        if (_expressList.count >0) {
            TypeViewController * vc = [[TypeViewController alloc] init];
            //构建TypeView的数据源
       
            vc.dataDict =@{@"payList":_fillinOrderModel.paymentList,@"expressList":_fillinOrderModel.expressList};
            
            vc.TypeVCBlock = ^(NSDictionary *selecteData){
                //1:更改支付配送界面
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
                DistributionTableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath1];
                [defaultDistributionDict setObject:[selecteData objectForKey:@"default_pay_id"] forKey:@"default_pay_id"];
                 [defaultDistributionDict setObject:[selecteData objectForKey:@"default_pay_name"] forKey:@"default_pay_name"];
                 [defaultDistributionDict setObject:[selecteData objectForKey:@"default_shipping_id"] forKey:@"default_shipping_id"];
                 [defaultDistributionDict setObject:[selecteData objectForKey:@"default_shipping_name"] forKey:@"default_shipping_name"];
      
                cell1.dict = defaultDistributionDict;
                
                //2:计算运费 金额
                [self moneyInfoArrAddObject:@{@"运费":[NSString stringWithFormat:@"+￥%.2f",[[selecteData objectForKey:@"yunfei"] floatValue]]}];
            };
            [self.lcNavigationController pushViewController:vc];
        }
        else
        {
            HUDSHOW(@"请先完善您的配送地址");
        }
    }
    
    if (indexPath.section == 3 && indexPath.row == 2 ) {
        //红包
        RedPacketViewController * redVC = [[RedPacketViewController alloc] init];
        redVC.bonus = _fillinOrderModel.bonus;
        redVC.rightbtnTitle = @"完成";
        if ([[defaultBonusDict objectForKey:@"bonus"] isKindOfClass:[NSNumber class]]) {
            NSNumber *number = [defaultBonusDict objectForKey:@"bonus"];
            redVC.bonus_id = [NSString stringWithFormat:@"%@",number];
        }else
            redVC.bonus_id = [defaultBonusDict objectForKey:@"bonus"];
        
        redVC.usedRedPacketBlokc = ^(NSDictionary *resultDict){
            NSIndexPath * index = [NSIndexPath indexPathForRow:2 inSection:3];
            RedPacketofAccountTableViewCell * cell = [tableView cellForRowAtIndexPath:index];
    
            defaultBonusDict =  @{@"bonus":[resultDict objectForKey:@"used_bouns_id"],@"bonusStr":[resultDict objectForKey:@"deductible_amount"]} ;
            cell.bonusDict = defaultBonusDict;
        };
        [self.lcNavigationController pushViewController:redVC];
    }
}
#pragma mark -- RedPacketofAccountTableViewCell DELEGATE
- (void)usedBonus:(NSDictionary *)data
{
    [self moneyInfoArrAddObject:data];
    
}
- (void)moneyInfoArrAddObject:(NSDictionary *)data
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:moneyInfoArr];
    BOOL search = false;
    for (int i = 0; i <moneyInfoArr.count; i++) {
        NSDictionary * dict = moneyInfoArr[i];
        if ([[data.allKeys firstObject] isEqualToString:[dict.allKeys firstObject]]) {
            [array replaceObjectAtIndex:i withObject:data];
            search = true;
        }
    }
    if (!search) {
        [array addObject:data];
    }
    moneyInfoArr = [NSMutableArray arrayWithArray:array];
    [self reloadSumCell];
}
- (void)moneyInfoArrRemoveObject:(NSString *)key
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:moneyInfoArr];
    for (int i = 0; i <moneyInfoArr.count; i++) {
        NSDictionary * dict = moneyInfoArr[i];
        if ([[dict.allKeys firstObject]isEqualToString:key]) {
            [array removeObjectAtIndex:i];
        }
    }
    moneyInfoArr = [NSMutableArray arrayWithArray:array];
    [self reloadSumCell];
}
#pragma mark -- CustomAlertView deleagte
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [customAlertView hide];
    }
    else
    {
        [self.lcNavigationController popViewController];
    }
}



#pragma mark --  get and set
- (void)setErr:(NSError *)err
{
    _err = err;
    FLog(@"%@",err);
    [self.view addSubview:self.faileView];
}
- (void)setFillinOrderModel:(FillInOrderModel *)fillinOrderModel
{
    
      _fillinOrderModel =  fillinOrderModel;
    
    //支付配送
    defaultDistributionDict = [NSMutableDictionary dictionary];
    [defaultDistributionDict setObject:fillinOrderModel.default_pay_type_id forKey:@"default_pay_id"];
    if ([fillinOrderModel.default_pay_type_id integerValue] > 0) {
        [defaultDistributionDict setObject:fillinOrderModel.default_pay_type_name forKey:@"default_pay_name"];
    }else
        [defaultDistributionDict setObject:@"未选择" forKey:@"default_pay_name"];
    
    [defaultDistributionDict setObject:fillinOrderModel.default_shipping_id forKey:@"default_shipping_id"];
    if ([fillinOrderModel.default_shipping_id integerValue] > 0) {
        [defaultDistributionDict setObject:fillinOrderModel.default_shipping_name forKey:@"default_shipping_name"];
    }else
        [defaultDistributionDict setObject:@"未选择" forKey:@"default_shipping_name"];
    
    _expressList = fillinOrderModel.expressList;
    //计算金额数据
    moneyInfoArr  = [NSMutableArray array];
    /**
     *  商品金额
     */
    [moneyInfoArr addObject:@{@"商品金额":[fillinOrderModel.total objectForKey:@"goods_price_formated"]}];
    /**
     *  折扣
     */
    
    NSString *discount = [fillinOrderModel.total objectForKey:@"discount_formated"];
    if ([[discount stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] floatValue] > 0) {
        [moneyInfoArr addObject:@{@"折扣": [NSString stringWithFormat:@"-%@",discount]}];
    }
    /**
     *  包装费
     */
    NSString *packFee = [fillinOrderModel.total objectForKey:@"pack_fee_formated"];
    if ([[packFee stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] floatValue] > 0) {
        [moneyInfoArr addObject:@{@"包装费":[NSString stringWithFormat:@"+%@",packFee]}];
    }
    /**
     *  贺卡费
     */
    NSString *cardFee = [fillinOrderModel.total objectForKey:@"card_fee_formated"];
    if ([[cardFee stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] floatValue] > 0) {
        [moneyInfoArr addObject:@{@"贺卡费": [NSString stringWithFormat:@"+%@",cardFee]}];
    }
    /**
     *  运费
     */
    [moneyInfoArr addObject:@{@"运费":[NSString stringWithFormat:@"+%@",[fillinOrderModel.total objectForKey:@"shipping_fee_formated"]]}];

    /**
     *  红包
     */
    NSString *bonus_formated = [fillinOrderModel.total objectForKey:@"bonus_formated"];
    if ([[bonus_formated stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] floatValue] > 0) {
        [moneyInfoArr addObject:@{@"红包抵扣": [NSString stringWithFormat:@"-%@",cardFee]}];
    }
    [self.view addSubview:self.tabView];
    
    [self.view addSubview:self.listView];
    [self jisuanzongjia];
}

- (NotReachView *)faileView
{
    if (!_faileView) {
        _faileView = [[NotReachView alloc] init];
        _faileView.error = _err;
        __WEAK_SELF_YLSLIDE
        _faileView.ReloadButtonBlock = ^{
            [weakSelf getOrderDate];
        };
    }
    return _faileView;
}
-(FillInOrderTabView *)tabView
{
    if(!_tabView)
    {
        _tabView =[[FillInOrderTabView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        __WEAK_SELF_YLSLIDE
        _tabView.FillInOrderButtonBlovk=^{
            [weakSelf updataOrderDataBtnClick];
        };
    }
    return _tabView;
}
-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
        _listView.delegate=self;
        _listView.dataSource =self;
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

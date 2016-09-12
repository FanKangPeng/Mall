//
//  ShopCartViewController.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "ShopCartViewController.h"

#import "FillInOrderViewController.h"
#import "ShoppingTool.h"
#import "UITabBar+Badge.h"
#import "FMDBManager.h"
@interface ShopCartViewController ()

@end

@implementation ShopCartViewController
#pragma mark - life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    if (isLogin) {
        [self getShoppingCatData];
    }
    else
    {
        [self initData];
    }
    //[super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     __WEAK_SELF_YLSLIDE
    ShopCartNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    if(self.isOtherVCPush)
    {
        tabHeight = kBottomBarHeight;
      
        [ShopCartNavigationView initViewWithTitle:@"购物车" andBack:@"icon_back.png" andRightName:@""];
        ShopCartNavigationView.CustomNavigationLeftImageBlock=^{
            //
            [weakSelf.view endEditing:YES];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf.lcNavigationController popViewController];
            });
        };
    }
    else
    {
        tabHeight = kBottomBarHeight*2;
         [ShopCartNavigationView initViewWithTitle:@"购物车" andBack:@"" andRightName:@""];
    }
    
    [self.view addSubview:ShopCartNavigationView];
    [self.view bringSubviewToFront:ShopCartNavigationView];
   

  //  [self loadNotificationCell];
  
    // Do any additional setup after loading the view.
    

    self.allPrice = 0.00;
      _totalYOffset = 0;
    self.editArray = [NSMutableArray array];
  
   

    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _sumTabView = nil;
    _tableView = nil;
    _editTabView = nil;
    _editBtn = nil;
    
}
/**
 *  导航右编辑按钮事件
 *
 *  @param rightBtn rightBtn
 */
- (void)rightBtnClick:(UIButton*)rightBtn
{
        if (!isEdit) {
            isEdit = YES;
            rightBtn.selected = YES;
            self.editTabView.hidden = NO;
            self.sumTabView.hidden = YES;
            
        }
        else
        {
            isEdit = NO;
            rightBtn.selected = NO;
            self.editTabView.hidden = YES;
            self.sumTabView.hidden = NO;
            //更新数据库或服务器数据
            //1:更新本地数据库
            if (!isLogin) {
              
                //1:更新数量
                if (self.editArray.count >0) {
                    for (int i =0 ; i < self.dataArray.count; i++) {
                        ShoppingModel *model = self.dataArray[i];
                        [FMDBManager updataCart:model];
                    }
                }
                
                //2：删除数据
                if (self.deleteArray.count>0) {
                    for (ShoppingModel *model in self.deleteArray) {
                        [FMDBManager delectCart:model];
                    }
                }
                
                
              
            }
            else
            {
                //更新服务器数据
                    if (self.editArray.count>0) {
                     //更新数量
                            for (ShoppingModel * model in self.editArray) {
                                [ShoppingTool ShoppingCartOperate:@"/cart/update" params:@{@"rec_id":model.rec_id,@"number":model.goods_number} success:^(id obj) {
                                    nil;
                                } failure:^(id obj) {
                                    nil;
                                }];
                            }
                    
                    }
                //删除
                if (self.deleteArray.count >0) {
                    for (ShoppingModel *model in self.deleteArray) {
                        [ShoppingTool ShoppingCartOperate:@"/cart/delete" params:@{@"rec_id":model.rec_id} success:^(id obj) {
                            nil;
                        } failure:^(id obj) {
                            nil;
                        }];
                    }
                }
            }
            
        }
        //更新数字图标
        int count = 0;
        for (ShoppingModel * xxxx in self.dataArray) {
            count += [xxxx.goods_number intValue];
        }
        [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count];
    if (_tableView) {
         [_tableView reloadData];
    }
    
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;;
    [self.view.layer removeAllAnimations];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
    
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:firstResponderView.frame fromView:firstResponderView.superview];
    
    CGFloat bottom = rect.origin.y + rect.size.height;
    CGFloat keyboardY = self.view.window.size.height - keyboardHeight;
    if (bottom > keyboardY) {
        _totalYOffset += bottom - (self.view.window.size.height - keyboardHeight);
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                         animations:^{
                             self.tableView.top = kNavigationHeight-_totalYOffset;
                         }
                         completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^{
                         self.tableView.top = kNavigationHeight;
                     }
                     completion:nil];
    _totalYOffset = 0;
}
-(void)tapClick:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)initCartView
{
    if (!_editBtn) {
        [ShopCartNavigationView addSubview:self.editBtn];
    }
    if (!_editTabView) {
        [self.view addSubview:self.editTabView];
        [self.view bringSubviewToFront:self.editTabView];
        [self.editTabView setHidden:YES];
        
        [_editTabView addSubview:self.editSelectAllBtn];
        _editSelectAllBtn.sd_layout
        .leftSpaceToView(_editTabView,kWidth(15))
        .topSpaceToView(_editTabView,(kBottomBarHeight/2-10))
        .widthIs(kWidth(60))
        .heightIs(kWidth(20));
        
        
        [_editTabView addSubview:self.editDeleteBtn];
        _editDeleteBtn.sd_layout
        .rightSpaceToView(_editTabView,KLeft)
        .topSpaceToView(_editTabView,KLeft)
        .bottomSpaceToView(_editTabView,KLeft)
        .widthIs(70);
        
        
        
    }
    
    if (!_sumTabView) {
        [self.view addSubview:self.sumTabView];
        [self.view bringSubviewToFront:self.sumTabView];
        
        [_sumTabView addSubview:self.selectAllBtn];
        [_sumTabView addSubview:self.totalMoneyLab];
        [_sumTabView addSubview:self.jieSuanBtn];
        
        _selectAllBtn.sd_layout
        .leftSpaceToView(_sumTabView,kWidth(15))
        .topSpaceToView(_sumTabView,(kBottomBarHeight/2-10))
        .widthIs(kWidth(60))
        .heightIs(kWidth(20));
        
        _jieSuanBtn.sd_layout
        .rightSpaceToView(_sumTabView,0)
        .topSpaceToView(_sumTabView,0)
        .bottomSpaceToView(_sumTabView,0)
        .widthIs(kWidth(110));
        
        _totalMoneyLab.sd_layout
        .rightSpaceToView(_jieSuanBtn,kWidth(5))
        .topSpaceToView(_sumTabView,(kBottomBarHeight/2-10))
        .bottomSpaceToView(_sumTabView,(kBottomBarHeight/2-10));
        

    }
    
    if(!_tableView)
    {
        [self.view addSubview:self.tableView];
        [self.view sendSubviewToBack:self.tableView];
    }
    else
    {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }

    
}


-(void)initFailView:(id)error
{
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getShoppingCatData];
        };
        [self.view addSubview:_noreachView];
        
        
    }
}
-(void)removeView
{
    if(_sumTabView)
    {
        [_sumTabView removeFromSuperview];
        _sumTabView = nil;
    }
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView  = nil;
    }
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    if(_netFaileView)
    {
        [_netFaileView removeFromSuperview];
        _netFaileView= nil;
    }
}
-(void)initNodataView
{
    if (!_netFaileView) {
        
        //购物车暂时为空
         __WEAK_SELF_YLSLIDE
        _netFaileView =[[NetFaileView alloc] initShopCartNullView:CGRectMake(0, kScreenHeight/4, kScreenWidth, kScreenHeight/2)];
        _netFaileView.StrollButtonBlock=^{
            //
            weakSelf.tabBarController.selectedIndex=0;
        };
        [self.view addSubview:_netFaileView];
        [self.view sendSubviewToBack:_netFaileView];
    }
}
#pragma mark - server methods
-(void)getShoppingCatData
{
  
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    
    [ShoppingTool getShoppingCartData:@"/cart/list" params:nil success:^(id obj) {
        [hud hide:YES];
         [self removeView];
        self.dataArray = [NSMutableArray arrayWithArray:obj];
        
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
//删除购物车
-(void)deleteShoppingCart:(ShoppingModel*)model
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [ShoppingTool ShoppingCartOperate:@"/cart/delete" params:@{@"rec_id":model.rec_id} success:^(id obj) {
        [hud hide:YES];
        [self getShoppingCatData];
    } failure:^(id obj) {
        [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            
            
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
            
        }
        
    }];
}

-(void)initData{
    
   self.dataArray = [NSMutableArray arrayWithArray:[FMDBManager selectCart]];
}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
     [self removeView];
    if (self.dataArray.count>0) {
        //2：数量图标
        int count = 0;
        for (ShoppingModel * xxxx in self.dataArray) {
            count += [xxxx.goods_number intValue];
        }
        [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count];
        //3:创建页面
        [self initCartView];
        //4：计算总价
        [self CalculationPrice];
        //5 :状态
         [self changeAllSelectedButtonState];
    }
    else
    {
        [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        [_sumTabView removeFromSuperview];
        _sumTabView = nil;
        [_editTabView removeFromSuperview];
        _editTabView = nil;
        [_editBtn removeFromSuperview];
        _editBtn = nil;
        [self initNodataView];
    }
    
}
#pragma mark - private methods
//结算
-(void)jieSuanAction{
    if (isLogin) {
        FillInOrderViewController * fillinOrderVC =[[FillInOrderViewController alloc] init];
        
        
        [self.lcNavigationController pushViewController:fillinOrderVC];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
    }
   
}

//全选
-(void)selectAllaction:(UIButton *)sender{
    
    if (!sender.selected)
    {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        
    }
    //改变单元格选中状态
    for (int i=0; i<self.dataArray.count;i++)
    {
        ShoppingModel *model = self.dataArray[i];
        model.selectState = sender.selected;
    }
    
    [self CalculationPrice];
    
    [self.tableView reloadData];
    
    
}
- (void)editSelectAllAction:(UIButton*)sender
{
    if (!sender.selected)
    {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        
    }
    //改变单元格选中状态
    for (int i=0; i<self.dataArray.count;i++)
    {
        ShoppingModel *model = self.dataArray[i];
        model.selectState = sender.selected;
    }
    [self.tableView reloadData];
    

    
}
//删除
- (void)editDeleteBtnClick:(UIButton*)sender{
    //遍历整个数据源，判断商品的选中状态 选中的删除 没有选中商品 提示
     BOOL haveSelected = false;
    self.deleteArray = [NSMutableArray array];
    NSMutableArray *editArr = [NSMutableArray arrayWithArray:self.dataArray];
    for (ShoppingModel *model in self.dataArray) {
        if (model.selectState) {
             haveSelected = YES;
            [self.deleteArray addObject:model];
            [editArr removeObject:model];
        }
    }
    
    
     _dataArray = editArr;
    
    if (!haveSelected) {
        HUDSHOW(@"未选中商品");
    }
    else
    {
       
        
        if (_dataArray.count >0) {
           
            [self.tableView reloadData];
        }
        else
        {
            //更改按钮状态 并提交数据
             [self rightBtnClick:self.editBtn];
             self.dataArray = [NSMutableArray arrayWithArray:editArr];
        }
        
        
    }
    
}

//计算价格
-(void)CalculationPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格(单价 * 商品数量)
    for ( int i =0; i<self.dataArray.count;i++)
    {
        ShoppingModel *model = self.dataArray[i];
        if (model.selectState)
        {
            CGFloat num  = [model.goods_number floatValue] ;
            NSString * pricestr = [model.goods_price stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            CGFloat price = [pricestr floatValue];
            self.allPrice = self.allPrice + (num * price);
        }
    }
    //给总价赋值
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总金额:￥%.2f元",self.allPrice]];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(17) range:NSMakeRange(5,str.length-5)];
    [str addAttribute:NSForegroundColorAttributeName value:NavigationBackgroundColor range:NSMakeRange(4,str.length-4)];
    self.totalMoneyLab.attributedText = str;
    
    self.allPrice = 0.0;
}
#pragma mark -UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr = @"ShopCarCell";
    
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if(!cell){
        
        cell = [[ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.delegate = self;
    cell.shoppingModel = self.dataArray[indexPath.section];
    
    cell.editV.hidden = !isEdit;
    cell.detailsV.hidden = isEdit;
    
   

    cell.deleteBlock = ^(ShoppingModel * model)
    {
        
        if (!isLogin) {
            //1:删除本地数据库
            [FMDBManager delectCart:model];
        }
        else
        {
            //1:删除服务器对应数据
            [self deleteShoppingCart:model];
        }
        
        //2:删除dataarray内对应的数据
        [self.dataArray removeObject:model];
        
        if (self.dataArray.count >0) {
            int count = 0;
            for (ShoppingModel * xxxx in self.dataArray) {
                count += [xxxx.goods_number intValue];
            }
            [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count];
        }
        else
        {
            self.dataArray = [NSMutableArray array];
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        
        //3:刷新列表
        [_tableView reloadData];
        
//        //1:删除本地数据库
//        [FMDBManager delectCart:model];
//        NSArray * arr =  [FMDBManager selectCart];
//        if (arr.count >0) {
//              [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:arr.count];
//        }
//        else
//        {
//            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:2];
//        }
//      
//        //2：删除服务器数据
//        
//        //3:刷新列表
//        self.dataArray = [NSMutableArray arrayWithArray:[FMDBManager selectCart]];
//        [_tableView reloadData];
//        weakell.editBtn.selected = false;
//        weakell.editV.hidden =! weakell.editBtn.selected;
//        weakell.detailsV.hidden = weakell.editBtn.selected;
        
        
        
    };
/*
    cell.updataBlock = ^(ShoppingModel * model)
    {
        [FMDBManager updataCart:model];
    };
*/
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat h = [self.tableView   cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.section] keyPath:@"shoppingModel" cellClass:[ShoppingCarCell class] contentViewWidth:kScreenWidth];
    
    return h;
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

//单元格选中事件
-(void)checkButtonClick:(UITableViewCell *)cell andState:(BOOL)selectType
{
    /**
     * 判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
     */
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShoppingModel *model = self.dataArray[indexPath.section];
    if (selectType)
    {
        model.selectState = YES;
    }
    else
    {
        model.selectState = NO;
    }
    
    [self changeAllSelectedButtonState];
    //刷新当前行
    // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self CalculationPrice];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (isEdit) {
//        return UITableViewCellEditingStyleNone;
//    }
//    else
        return UITableViewCellEditingStyleDelete;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ShoppingModel * model = self.dataArray[indexPath.section];
        if (!isLogin) {
            //1:删除本地数据库
            [FMDBManager delectCart:model];
        }
        else
        {
            //1:删除服务器对应数据
            [self deleteShoppingCart:model];
        }
        
        //2:删除dataarray内对应的数据
        [self.dataArray removeObjectAtIndex:indexPath.section];
       
        if (self.dataArray.count >0) {
            int count = 0;
            for (ShoppingModel * xxxx in self.dataArray) {
                count += [xxxx.goods_number intValue];
            }
            [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count];
        }
        else
        {
            self.dataArray = [NSMutableArray array];
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        
        //3:刷新列表
        [_tableView reloadData];
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return kWidth(8);
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(8))];
    [view setBackgroundColor:BackgroundColor];
    return view;
    
}
#pragma mark - setter and getter
- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_editBtn setFrame:CGRectMake(kScreenWidth-100, 20, 85, 44)];
        [_editBtn setTitle:@"编辑" forState:0];
        [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_editBtn.titleLabel setFont:DefaultFontSize(14)];
         _editBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [_editBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
- (UIButton *)editDeleteBtn
{
    if (!_editDeleteBtn) {
        _editDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editDeleteBtn.layer.cornerRadius = 3;
        _editDeleteBtn.layer.borderColor = NavigationBackgroundColor.CGColor;
        _editDeleteBtn.layer.borderWidth =1 ;
        _editDeleteBtn.layer.masksToBounds = YES;
        [_editDeleteBtn setTitle:@"删除" forState:0];
        [_editDeleteBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_editDeleteBtn.titleLabel setFont:DefaultFontSize(14)];
        [_editDeleteBtn addTarget:self action:@selector(editDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editDeleteBtn setSelected:YES];
    }
    return _editDeleteBtn;
}
- (UIView *)editTabView
{
    if (!_editTabView) {
        _editTabView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-tabHeight, kScreenWidth, kBottomBarHeight)];
        [_editTabView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        UILabel * line =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SINGLE_LINE_WIDTH)];
        [line setBackgroundColor:ShiXianColor];
        [_editTabView addSubview:line];
    }
    return _editTabView;
}
- (UIView *)sumTabView
{
    if (!_sumTabView) {
        _sumTabView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-tabHeight, kScreenWidth, kBottomBarHeight)];
        [_sumTabView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        UILabel * line =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SINGLE_LINE_WIDTH)];
        [line setBackgroundColor:ShiXianColor];
        [_sumTabView addSubview:line];
        
    }
    return _sumTabView;
}
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth,kScreenHeight-kNavigationHeight-tabHeight) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        [_tableView setBackgroundColor:BackgroundColor];
        UIView * view1 =[[UIView alloc] init];
        [view1 setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:view1];
  
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.mj_header =[CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewReload)];
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
- (void)tableViewReload
{
    if (isLogin) {
        [self getShoppingCatData];
    }
    else
    {
        [self.tableView reloadData];
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       [self.tableView.mj_header endRefreshing];
    });
   
}
- (UIButton *)editSelectAllBtn
{
    if (!_editSelectAllBtn) {
        _editSelectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editSelectAllBtn.frame = CGRectMake(15,kBottomBarHeight/2-10, 60, 20);
        [_editSelectAllBtn setImage:ImageName(@"icon_choice") forState:UIControlStateNormal];
        [_editSelectAllBtn setImage:ImageName(@"icon_choice_selected") forState:UIControlStateSelected];
        _editSelectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,kWidth(40));
        [_editSelectAllBtn addTarget:self action:@selector(editSelectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editSelectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        _editSelectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWidth(-25), 0, 0);
        [_editSelectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editSelectAllBtn.titleLabel.font = DefaultFontSize(15.0);
        _editSelectAllBtn.selected = NO;
    }
    return _editSelectAllBtn;
}
-(UIButton *)selectAllBtn
{
    if(!_selectAllBtn)
    {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame = CGRectMake(15,kBottomBarHeight/2-10, 60, 20);
        [_selectAllBtn setImage:ImageName(@"icon_choice") forState:UIControlStateNormal];
        [_selectAllBtn setImage:ImageName(@"icon_choice_selected") forState:UIControlStateSelected];
        _selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,kWidth(40));
        [_selectAllBtn addTarget:self action:@selector(selectAllaction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        _selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWidth(-25), 0, 0);
        [_selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = DefaultFontSize(15.0);
        _selectAllBtn.selected = YES;
    }
        
        return _selectAllBtn;
}
-(UILabel *)totalMoneyLab
{
    if(!_totalMoneyLab)
    {
        for ( int i =0; i<self.dataArray.count;i++)
        {
            ShoppingModel *model = self.dataArray[i];
            if (model.selectState)
            {
                CGFloat num  = [model.goods_number floatValue] ;
                NSString * pricestr = [model.goods_price stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                CGFloat price = [pricestr floatValue];
                self.allPrice = self.allPrice + (num * price);
            }
        }
        
        _totalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(self.selectAllBtn.right+10,kBottomBarHeight/2-10, kScreenWidth-self.selectAllBtn.right-30-GetWidth(184),20)];
        _totalMoneyLab.textColor =[UIColor whiteColor];
        _totalMoneyLab.textAlignment = NSTextAlignmentCenter;
        _totalMoneyLab.font = DefaultFontSize(13.0);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总金额:￥%.2f元",self.allPrice]];
        
        [str addAttribute:NSFontAttributeName value:DefaultFontSize(17) range:NSMakeRange(5,str.length-5)];
        [str addAttribute:NSForegroundColorAttributeName value:NavigationBackgroundColor range:NSMakeRange(4,str.length-4)];
       _totalMoneyLab.attributedText = str;
    }
    self.allPrice = 0.0;
    
    return _totalMoneyLab;
}
-(UIButton *)jieSuanBtn
{
    if(!_jieSuanBtn)
        
    {
       _jieSuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _jieSuanBtn.frame = CGRectMake(kScreenWidth-90-10,0,90,kBottomBarHeight);
        [_jieSuanBtn setBackgroundColor:NavigationBackgroundColor];
        [_jieSuanBtn addTarget:self action:@selector(jieSuanAction) forControlEvents:UIControlEventTouchUpInside];
        [_jieSuanBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_jieSuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _jieSuanBtn.titleLabel.font = DefaultBoldFontSize(16);
       _jieSuanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _jieSuanBtn;
}



#pragma mark -- 实现加减按钮点击代理事件
/**
 * 实现加减按钮点击代理事件
 *
 * @param cell 当前单元格
 * @param flag 按钮标识，11 为减按钮，12为加按钮
 */



-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    switch (flag) {
        case 12:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            ShoppingModel *model = self.dataArray[index.section];
            if ([model.goods_number intValue] > 5)
            {
                int number = [model.goods_number intValue] - 5 ;
                model.goods_number = [NSString stringWithFormat:@"%d",number];
            }
            model.selectState = YES;
            
           
        }
            break;
        case 11:
        {
            //做加法
            ShoppingModel *model = self.dataArray[index.section];
            int number = [model.goods_number intValue] + 5 ;
            model.goods_number = [NSString stringWithFormat:@"%d",number] ;
            model.selectState = YES;
            
            
        }
            break;
    
        default:
            break;
    }
    
    
     //记录下对应的model 用于更新服务器数据
    //1:如果editArr中有该model 先移除 再添加

        ShoppingModel *editModel = self.dataArray[index.section];
    
    
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.editArray];
        for (ShoppingModel * www  in self.editArray) {
            if ([editModel.rec_id isEqualToString:www.rec_id]) {
                [array removeObject:www];
            }
        }
        [array addObject:editModel];
    self.editArray = [NSMutableArray arrayWithArray:array];

    
    
    
    
    [self changeAllSelectedButtonState];
    //刷新表格
    [self.tableView reloadData];
    //计算总价
    [self CalculationPrice];
    
    //更新数据库 和服务器 
    
}
-(void)changeAllSelectedButtonState
{
    NSMutableArray * stateArr =[NSMutableArray array];
    for (ShoppingModel * shopModel in self.dataArray) {
        if(shopModel.selectState)
            [stateArr addObject:@"YES"];
        else
            [stateArr addObject:@"NO"];
    }
    NSSet *set = [NSSet setWithArray:stateArr];
    if(set.allObjects.count==1)
    {
        //表示全选或全不选
        if([set.allObjects.lastObject isEqualToString:@"YES"])
        {
            self.selectAllBtn.selected = YES;
            self.editSelectAllBtn.selected = YES;
        }
        else
        {
            self.editSelectAllBtn.selected = NO;
            self.selectAllBtn.selected = NO;
        }
    }
    else
    {
        self.editSelectAllBtn.selected = NO;
        self.selectAllBtn.selected = NO;
    }

}
#pragma mark - UITexeField delegate
-(void)textFileBeginEditDelegate:(UITextField *)textField andCell:(UITableViewCell *)cell
{
    
    
}
-(void)textFileEndEditDelegate:(UITextField *)textField andCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    ShoppingModel *model = self.dataArray[index.section];

    model.goods_number = textField.text;

    model.selectState = YES;
    
    //记录下对应的model 用于更新服务器数据
    //1:如果editArr中有该model 先移除 再添加
    
    ShoppingModel *editModel = self.dataArray[index.section];
    
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.editArray];
    for (ShoppingModel * www  in self.editArray) {
        if ([editModel.rec_id isEqualToString:www.rec_id]) {
            [array removeObject:www];
        }
    }
    [array addObject:editModel];
    self.editArray = [NSMutableArray arrayWithArray:array];

    [self changeAllSelectedButtonState];
    //刷新表格
    [self.tableView reloadData];
    //计算总价
    [self CalculationPrice];

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

//
//  MaskDetailViewController.m
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "MaskDetailViewController.h"

#import"ShareManager.h"

#import "CustomNavigationView.h"
#import "GoodCommentViewController.h"
#import "WXApiManager.h"
#import "ShopCartViewController.h"
#import "FillInOrderViewController.h"
#import "GoodsTool.h"
#import "ShoppingTool.h"
#import "CommunityTool.h"
#import "EstimateTableViewCell.h"
#import "FMDBManager.h"
#import "HomeDataTool.h"
@interface MaskDetailViewController ()

@end

@implementation MaskDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (_noreachView || _goodModel || _firstTableView) {
        [self getGoodDATA];
    }
    
   // [self manageCartCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:BackgroundColor];
    maskDetailNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [maskDetailNavigationView initViewWithTitle:@"商品详情" andBack:@"icon_back.png" andRightName:@"icon_right_share.png" ];
    [self.view addSubview:maskDetailNavigationView];
    __WEAK_SELF_YLSLIDE
    maskDetailNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf back];
    };
    
    self.changedGoodCount = @"5";
    [self getGoodDATA];
  
    // Do any additional setup after loading the view.
}
- (UIButton *)jumpBtn
{
    if (!_jumpBtn) {
        _jumpBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpBtn setFrame:CGRectMake(maskDetailNavigationView.frame.size.width-75, 20, 44, 44)];
        [_jumpBtn setBackgroundImage:[UIImage imageNamed:@"icon_jump_shopCart"] forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpToCartClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _jumpBtn;
}

//- (void)setCart_number:(NSString *)cart_number
//{
//    _cart_number = cart_number;
//    if ([cart_number intValue] < 1) {
//        [self.detailTabView.cartNumLb setHidden:YES];
//    }
//    else
//    {
//         [self.detailTabView.cartNumLb setHidden:NO];
//        if ([cart_number intValue] > 99) {
//            self.detailTabView.cartNumLb.text = [NSString stringWithFormat:@"%d+",99];
//        }
//        else
//            self.detailTabView.cartNumLb.text = _cart_number;
//    }
//   
//    
//}
/**
 *  购物车图标数量处理
 *
 *  @return
 */
//- (void)manageCartCount
//{
//    if (!isLogin) {
//        int  count  = [FMDBManager selectCount];
//        _cart_number = [NSString stringWithFormat:@"%d",count];
//    }
//    else
//    {
//        //从服务器获取
//        [HomeDataTool getsomeThing:@"/cart/number" success:^(id obj) {
//            NSDictionary * dict = [obj objectForKey:@"data"];
//            NSString * str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cart_number"]];
//            if ([str isEqualToString:@"<null>"]) {
//             
//                _cart_number = @"0";
//            }
//            else
//               _cart_number = str;
//            
//            
//            
//        } failure:^(id obj) {
//            _cart_number = @"0";
//        }];
//        
//    }
//    
//}


-(void)getGoodDATA
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [GoodsTool getgoodDetail:@"/goods/detail" params:@{@"id":self.good_id} success:^(id obj) {
        [hud hide:YES];
        self.goodModel = obj;
        [self initView];
    } failure:^(id obj) {
         [hud hide:YES];
        [self initFailView:obj];
    }];
}
-(void)initView
{
    
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    
    
    if(!_backgroundScrollView)
    {
        [self.view addSubview:self.backgroundScrollView];
    }
    else
    {
        [self.firstTableView.mj_footer endRefreshing];
        [self.firstTableView.mj_header endRefreshing];
        [self.firstTableView reloadData];
         _secondView.goodModel = self.goodModel;
    }
    if (!_detailTabView) {
        [self.view addSubview:self.detailTabView];
    }
    else
        self.detailTabView.goodModel =self.goodModel;
}
-(void)initFailView:(id)error
{
    if(_noreachView)
    {
        [_noreachView removeFromSuperview];
        _noreachView= nil;
    }
    if (!_noreachView) {
        __WEAK_SELF_YLSLIDE
        _noreachView  =[[NotReachView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
        _noreachView.error = error;
        _noreachView.ReloadButtonBlock=^{
            [weakSelf getGoodDATA];
        };
        [self.view addSubview:_noreachView];
    }
}
-(void)jumpToCartClick:(UIButton*)button
{
    ShopCartViewController * shopCartVC  =[[ShopCartViewController alloc] init];
    shopCartVC.isOtherVCPush = YES;
    [self.lcNavigationController pushViewController:shopCartVC];
}
#pragma  mark CustomNavigationDelegate
-(void)back
{
    [self.lcNavigationController popViewControllerCompletion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:[MaskDetailSecondTableViewCell class]];
    }];
}


-(DetailTabView *)detailTabView
{
    if (!_detailTabView) {
        _detailTabView  =[[DetailTabView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        
        _detailTabView.goodModel =self.goodModel;
        __WEAK_SELF_YLSLIDE
        _detailTabView.DetailTabViewBlock1=^() {
            [weakSelf jumpToCartClick:nil];
            
        };
        _detailTabView.DetailTabViewBlock2=^() {
            //加入购物车
          
                    [weakSelf chanceSpecificationWithType:@"shopcart"];
            
        };
        _detailTabView.DetailTabViewBlock3 =^() {
            //跳转到购买  -
            if (isLogin) {
                 [weakSelf chanceSpecificationWithType:@"pay"];
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
        };
    }
    return _detailTabView;
}
-(void)shoucange
{
   
    
}

-(UIScrollView *)backgroundScrollView
{
    if (!_backgroundScrollView) {
        _backgroundScrollView  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight)];
        [_backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, (kScreenHeight-113)*2)];
        _backgroundScrollView.scrollEnabled=NO;
        [_backgroundScrollView addSubview:self.firstTableView];
        [_backgroundScrollView addSubview:self.secondView];
    }
    return _backgroundScrollView;
}
-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _backgroundScrollView.frame.size.height) style:UITableViewStylePlain];
        _firstTableView.delegate =self;
        _firstTableView.dataSource =self;
        _firstTableView.tableFooterView = self.tableViewFootView;
        if([_firstTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_firstTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_firstTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_firstTableView setLayoutMargins:UIEdgeInsetsZero];
        }

        [_firstTableView setBackgroundColor:BackgroundColor];
    }
    return _firstTableView;
}
-(UIView *)tableViewFootView
{
    if (!_tableViewFootView) {
        _tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, kScreenWidth, 40)];
        [_tableViewFootView setBackgroundColor:[UIColor clearColor]];
        UILabel * label  =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-47, 11, 130, 20)];
        label.text=@"上拉查看图文详情";
        label.font =DefaultFontSize(14);
        [label setTextColor:[UIColor colorWithRed:102.00/255.00 green:102.00/255.00 blue:102.00/255.00 alpha:1]];
        [_tableViewFootView addSubview:label];
        
        UIImageView * image =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-66, 16, 16, 9)];
        image.image =[UIImage imageNamed:@"icon_scrollView_top"];
        [_tableViewFootView addSubview:image];
    }
    return _tableViewFootView;
}
-(SecondView *)secondView
{
    if (!_secondView) {
        _secondView =[[SecondView alloc] initWithFrame:CGRectMake(0, _backgroundScrollView.frame.size.height, kScreenWidth,  _backgroundScrollView.frame.size.height)];
        _secondView.delegate=self;
        _secondView.goodModel =self.goodModel;
      
    }
    return _secondView;
}
-(void)chanceSpecificationWithType:(NSString*)type
{
        _menu =nil;
    
        _menu = [[ChanceSpecificationViewController alloc] initWithContent:self.goodModel.specification];
        [_menu setDelegate:self];
        _menu.actionType = type;
        _menu.good_count = _changedGoodCount;
        _menu.goodModel =self.goodModel;
      [_menu showInView:[self view]];
}

#pragma mark - MBButtonMenuViewControllerDelegate

- (void)buttonMenuViewController:(ChanceSpecificationViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index
{
    [buttonMenu hide];
}

-(void)buttonMenuViewControllerDidCancel:(ChanceSpecificationViewController *)buttonMenu andPushID:(id)model andType:(NSString *)typeStr andPoint:(CGPoint)point andImage:(UIImage *)image
{
    
    //改变选择的数量  规格
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSize" object:@{@"count":model}];
    self.changedGoodCount =  [model objectForKey:@"num"];
    //购物车
    if([typeStr isEqualToString:@"shopcart"])
    {
        //动画
        //        self.path = [UIBezierPath bezierPath];
        //        [_path moveToPoint:point];
        //        [_path addQuadCurveToPoint:CGPointMake(kScreenWidth-58, 42) controlPoint:CGPointMake((kScreenWidth-58-point.x)/2, (point.y-43)/2)];
        //
        //
        //        [self startAnimationWithImage:image andPoint:point];
        
        //加入购物车 接口
        [self joinShoppingCart:model];
        
    }
    //去支付
    if([typeStr isEqualToString:@"pay"])
    {
        [self createOrder:model];
        
    }
    
}

#pragma mark   _secondView delegate
-(void)buyerEstimate
{
    GoodCommentViewController * listVC = [[GoodCommentViewController alloc] init];
    listVC.good_id =self.goodModel.id;
    [self.lcNavigationController pushViewController:listVC];
}

-(void)backTop
{
    [UIView animateWithDuration:.5 animations:^{
      _backgroundScrollView.contentOffset= CGPointMake(0, 0);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -50)
     {
         [UIView animateWithDuration:1 animations:^{
             _backgroundScrollView.contentOffset= CGPointMake(0, _backgroundScrollView.frame.size.height);
        }];
     }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -50)
    {
        [UIView animateWithDuration:1 animations:^{
            _backgroundScrollView.contentOffset= CGPointMake(0, _backgroundScrollView.frame.size.height);
            
        }];
    }
}
- (float)contentOffsetBottom:(UIScrollView *)scrollView
{
    return scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom);
}
#pragma tableview delegate and datesource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4+self.goodModel.cmt.count;

   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __WEAK_SELF_YLSLIDE
    if(indexPath.section==0)
    {
        MaskDetailFirstTableViewCell * maskFirstCell  =[tableView dequeueReusableCellWithIdentifier:@"MaskDetailFirstTableViewCell"];
        if(maskFirstCell ==nil)
        {
            maskFirstCell =[[MaskDetailFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaskDetailFirstTableViewCell"];
        }
        maskFirstCell.goodModel =self.goodModel;
        maskFirstCell.delegate=self;
        maskFirstCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return maskFirstCell;
    }
    if(indexPath.section==1)
    {
        MaskDetailSecondTableViewCell * maskSecondCell  =[tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
        if(maskSecondCell ==nil)
        {
            maskSecondCell =[[MaskDetailSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondCell"];
        }
        maskSecondCell.selectionStyle =UITableViewCellSelectionStyleNone;
        maskSecondCell.goodModel = self.goodModel;
        maskSecondCell.dict = @{@"count":@"5"};
        maskSecondCell.SpecificationBlock = ^{
             [weakSelf chanceSpecificationWithType:@""];
        };

        [maskSecondCell setNoticeBlock:^{
            //
            
        }];
        return maskSecondCell;
    }
    if(indexPath.section==2)
    {
        MaskDetailThreeTableViewCell * maskThreeCell  =[tableView dequeueReusableCellWithIdentifier:@"ThreeCell"];
        if(maskThreeCell ==nil)
        {
            maskThreeCell =[[MaskDetailThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThreeCell" andMask:nil];
        }
        maskThreeCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return maskThreeCell;
    }
    if(indexPath.section==3)
    {
        MaskDetailFourTableViewCell * maskFourCell  =[tableView dequeueReusableCellWithIdentifier:@"FourCell"];
        if(maskFourCell ==nil)
        {
            maskFourCell =[[MaskDetailFourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FourCell"];
        }
        maskFourCell.goodModel = self.goodModel;
        maskFourCell.selectionStyle =UITableViewCellSelectionStyleNone;

        return maskFourCell;
    }
    else
    {
        EstimateTableViewCell * estimateCell =[tableView dequeueReusableCellWithIdentifier:@"EstimateTableViewCell"];
        if(estimateCell  ==  nil)
        {
            estimateCell =[[EstimateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EstimateTableViewCell"];
        }
        
        estimateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        EstimateModel  * model =[EstimateModel mj_objectWithKeyValues:self.goodModel.cmt[indexPath.section-4]];
        estimateCell.model = model;
        return estimateCell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        CGFloat height = [self.firstTableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView];
        return height;
    }
    else if (indexPath.section==1) {
  
        return 150;
    }
    else if (indexPath.section==2) {
      
        return 60;
    }
    else if (indexPath.section==3) {
  
        return kBottomBarHeight;
    }
    else
    {
      
        CGFloat height = [self.firstTableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView];
        return height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        GoodCommentViewController * listVC = [[GoodCommentViewController alloc] init];
        listVC.good_id =self.goodModel.id;
        [self.lcNavigationController pushViewController:listVC];
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
#pragma mark cellDelegate


-(void)toImageDetail
{
    [UIView animateWithDuration:1 animations:^{
        _backgroundScrollView.contentOffset= CGPointMake(0, _backgroundScrollView.frame.size.height);
    }];
}
#pragma mark shareAction

-(void)shareBtnClick:(UIButton*)shareBtn
{
   [[ShareManager sharedInstance]createShareContentWithShareDict:nil andShareView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark   加入购物车   生成订单
-(void)joinShoppingCart:(id)model
{
   NSDictionary * modelDict = model;
    FLog(@"%@",modelDict);

    if (!isLogin) {
        //把商品加入本地数据库
        [FMDBManager addCart:[ShoppingModel createModelByShopID:self.goodModel.id imageName:[self.goodModel.img objectForKey:@"cover"] goodsTitle:self.goodModel.goods_name goodsType:@"0" goodsPrice:self.goodModel.shop_price selectState:YES goodsNum:[modelDict objectForKey:@"num"] isshopping:@"0" isgift:@"0"]];
         HUDSHOW(@"加入购物车成功");
    }
    else
    {
        [GoodsTool postData:@"/cart/create" params:@{@"id":self.goodModel.id,@"number":[modelDict objectForKey:@"num"],@"spec":@"",@"quick":@"0"} success:^(id obj) {
       //     _cart_number = [[obj objectForKey:@"data"] objectForKey:@"cart_number"];
            FLog(@"cart_number == %@",_cart_number);
            HUDSHOW(@"加入购物车成功");
            
        } failure:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * er = obj;
                if ([[er.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
                    
                      HUDSHOW(@"加入购物车成功");
                }
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
        }];
    }
   
}
-(void)createOrder:(id)model
{
    NSDictionary * modelDict = model;
    FLog(@"%@",modelDict);
    
        [GoodsTool postData:@"/cart/create" params:@{@"id":self.goodModel.id,@"number":[modelDict objectForKey:@"num"],@"spec":@"",@"quick":@"1"} success:^(id obj) {
            //     _cart_number = [[obj objectForKey:@"data"] objectForKey:@"cart_number"];
            FLog(@"cart_number == %@",_cart_number);
            [self.lcNavigationController pushViewController:[[FillInOrderViewController alloc] init]];
            
        } failure:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * er = obj;
                if ([[er.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"暂无数据"]) {
                    
                  
                }
            }
            
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
        }];
}

@end

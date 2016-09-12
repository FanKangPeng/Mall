//
//  MaskDetailViewController.h
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "SecondView.h"
#import "MaskDetailFirstTableViewCell.h"
#import "MaskDetailSecondTableViewCell.h"
#import "MaskDetailThreeTableViewCell.h"
#import "MaskDetailFourTableViewCell.h"
#import "ChanceSpecificationViewController.h"
#import "GoodModel.h"
#import "DetailTabView.h"

@interface MaskDetailViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,SecondViewDelegate,UIScrollViewDelegate,MaskDetailFirstDelegate,ChanceSpecificationViewControllerDelegate,UIGestureRecognizerDelegate>
{
    CustomNavigationView *maskDetailNavigationView;
}
@property (nonatomic ,copy) NSString *cart_number;



@property (nonatomic ,strong) UIButton * jumpBtn;
/**底部悬浮按钮view*/
@property (nonatomic,strong)DetailTabView * detailTabView;
/**主体ScrollView*/
@property (nonatomic,strong)UIScrollView * backgroundScrollView;
/**第二页View*/
@property (nonatomic,strong)SecondView * secondView;
/**第一页View -- UITableView*/
@property (nonatomic,strong)UITableView * firstTableView;
/**产品ID*/
@property (nonatomic,copy)NSString * good_id;
/**规格选择View*/
@property (nonatomic,strong)ChanceSpecificationViewController *menu;
/**图片数组*/
@property (nonatomic,strong)NSArray * imageArr;
/**path*/
@property (nonatomic,strong)UIBezierPath *path;
/**产品model*/
@property (nonatomic,strong)GoodModel * goodModel;
/***/
@property (nonatomic,strong)NotReachView * noreachView;
@property (nonatomic,strong)UIView * tableViewFootView;
/**全局变量 记录选择的产品的数量*/
@property (nonatomic,copy)NSString * changedGoodCount;
/**声明字符串用copy 是为了避免拷贝可变字符串的时候改变其父类NSString的值，copy会进行一次深拷贝生成一个新的对象，从而不会改变NSString的值，用strong 只会引用计数增加，会导致NSMutableNSString 和NSString都改变*/
@end

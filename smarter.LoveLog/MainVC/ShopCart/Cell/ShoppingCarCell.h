//
//  ShoppingCarCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingModel.h"

#import "AddNumberView.h"


@protocol ShoppingCarCellDelegate;
@interface ShoppingCarCell : UITableViewCell<AddNumberViewDelegate>


@property (nonatomic ,strong) UIView *titleV;

@property (nonatomic ,strong) UILabel *titleLb;

@property (nonatomic ,strong) UIButton *editBtn;


@property (nonatomic ,strong) UIView *contentV;

@property (nonatomic,strong) UIButton *checkBtn;

@property (nonatomic,strong) UIImageView *shopImageV;

@property (nonatomic ,strong) UIView *detailsV;

@property (nonatomic,strong) UILabel *shopNameLb;

@property (nonatomic,strong) UILabel *priceLb;

@property (nonatomic ,strong) UIView *editV;

@property (nonatomic,strong) UILabel *shopNameLb2;

@property (nonatomic,strong) AddNumberView *addNumberView;

@property (nonatomic ,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UILabel *shopTypeLb;//商品型号

@property (nonatomic,strong)UILabel *numberTitleLb;

/**
 *  是否免邮
 */
@property (nonatomic ,strong) UILabel *is_shoppingLb;
/**
 *  是否是赠品
 */
@property (nonatomic ,strong) UILabel *is_giftLb;

@property (nonatomic,strong) ShoppingModel *shoppingModel;

@property (assign,nonatomic) BOOL selectState;//选中状态

@property (nonatomic,assign) id<ShoppingCarCellDelegate>delegate;

@property (nonatomic ,copy) void (^deleteBlock)(ShoppingModel * model);

@property (nonatomic ,copy) void (^updataBlock)(ShoppingModel * model);


@end

@protocol ShoppingCarCellDelegate

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;
-(void)checkButtonClick:(UITableViewCell*)cell  andState:(BOOL)selectType;
-(void)textFileBeginEditDelegate:(UITextField*)textField andCell:(UITableViewCell*)cell;

-(void)textFileEndEditDelegate:(UITextField*)textField andCell:(UITableViewCell*)cell;
@end

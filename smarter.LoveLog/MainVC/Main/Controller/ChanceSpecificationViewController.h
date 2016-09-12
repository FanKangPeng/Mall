//
//  ChanceSpecificationViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/15.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNumberView.h"
#import "GoodModel.h"
#import "TypeView.h"
#import "BuyCountView.h"
#import "ShoppingModel.h"
@protocol ChanceSpecificationViewControllerDelegate;
@interface ChanceSpecificationViewController : UIViewController<AddNumberViewDelegate>
@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, assign) BOOL shrinksParentView;

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) TypeView * sizeView;
@property (nonatomic,strong) BuyCountView * countView;
@property (nonatomic ,strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) NSUInteger buttonTag;
@property (nonatomic,strong) UIView * buttonBackgroundView;


@property (nonatomic, assign) id<ChanceSpecificationViewControllerDelegate> delegate;

@property (nonatomic,strong)GoodModel * goodModel;

@property (nonatomic,strong)NSString * actionType;

@property (nonatomic,strong)NSString * ProductType;

@property (nonatomic,strong)UIImageView * imageName;

@property (nonatomic,copy) NSString * good_count;

@property (nonatomic,strong) UIButton * sureButton;

- (id)initWithContent:(NSArray *) content;

- (void) showInView:(UIView*)view;
- (void) hide  ;
@end


@protocol ChanceSpecificationViewControllerDelegate <NSObject>

- (void) buttonMenuViewController:(ChanceSpecificationViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index;
- (void) buttonMenuViewControllerDidCancel:(ChanceSpecificationViewController *)buttonMenu andPushID:(id)model andType:(NSString*)typeStr andPoint:(CGPoint)point andImage:(UIImage*)image;

@end

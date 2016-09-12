//
//  ChanceSpecificationViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/15.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "ChanceSpecificationViewController.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ChanceSpecificationViewController ()
@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, assign) UIView *shrunkView;
@property (nonatomic,strong) UIImageView * goodImage;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * countLabel;
@property (nonatomic,strong) UIButton * cancelButton;

@end

@implementation ChanceSpecificationViewController


- (id)init
{
    self = [super init];
    if (self) {
        
        //A dark gray color is the default
        _backgroundColor = [UIColor whiteColor];
        
        //  The modal view
        _modalView = [UIView new];
        [_modalView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
        
        //  The visible view
        _buttonView = [[UIView alloc] init];
        [_buttonView setBackgroundColor:_backgroundColor];
        
        
        //  Should the parent view shrink down?
        _shrinksParentView = NO;
        
        self.ProductType = @"青春版";
        
    }
    return self;
}

-(id)initWithContent:(NSArray *)content
{
    self = [self init];
    if (self) {
        
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //  1. Set view to be transparent - with autoresizing
    [[self view] setOpaque:NO];
    [[self view] setBackgroundColor:[UIColor clearColor]];
//    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  2. Add a modal overlay - with autoresizing
    [[self view] addSubview:self.modalView];
    [self.modalView setFrame:[[self view] bounds]];
    [self.modalView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  3. Add a sheet that's one third of the screen
    [[self view] addSubview:_buttonView];
    
    // Position at the bottom of the screen
    [self.buttonView setFrame:CGRectMake(0,kScreenHeight/2, kScreenWidth, kScreenHeight/2)];
   // [self.buttonView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    
    //  4. Put a scroll view in there
    //    [_buttonView addSubview:_buttonWrapper];
    //    [_buttonWrapper setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //    [_buttonWrapper setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self initMainView];
    
}
#pragma mark 键盘
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    [UIView animateWithDuration:1 animations:^{
        self.buttonView.top = kScreenHeight/2;
    }];
    
}

- (void)handleKeyboardWillShow:(NSNotification *)notification
{
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [_mainScrollView setContentOffset:CGPointMake(0, _countView.top)];
    [UIView animateWithDuration:animationDuration animations:^{
        self.buttonView.top = kScreenHeight/3;
    }];
}



- (void)dealloc {
    //反注册通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        _cancelButton.layer.borderColor=[UIColor grayColor].CGColor;
        [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelButton;
}
-(UIImageView *)goodImage
{
    if (!_goodImage) {
        _goodImage = [UIImageView new];
        _goodImage.layer.cornerRadius=5;
        _goodImage.layer.masksToBounds=YES;
        _goodImage.layer.borderColor=[UIColor whiteColor].CGColor;
        _goodImage.layer.borderWidth=5;
    }
    return _goodImage;
}

-(UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton=[UIButton  buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton .titleLabel setFont:DefaultFontSize(16)];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:NavigationBackgroundColor];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchDown];
        
        
    }
    return _sureButton;
}

- (TypeView *)sizeView
{
    if (!_sizeView) {
        //self.goodModel.specification
      __block  NSArray * nameArr  = @[@"青春版",@"校园版活力版",@"活力版活力版活力版活力版",@"校园版",@"活力版活力版",@"校园版",@"活力版活",@"校园版",@"活力活力版版",@"校园版",@"活力版",@"校园版",@"活力版",@"校园版",@"活力版",@"校园版",@"活力版"];
        _sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) andData:nameArr title:@"版本"];
        __WEAK_SELF_YLSLIDE
        
        
        __weak TypeView * view = _sizeView;
        
        _sizeView.typeViewButtonBlock = ^(NSUInteger tag){
            
            [weakSelf resumeBtn:nameArr :view];
            
        };
    }
    return _sizeView;
}
- (BuyCountView *)countView
{
    if (!_countView) {
        _countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _countView.addView.delegate = self;
    }
    return _countView;
}
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [UIScrollView new];
    }
    return _mainScrollView;
}


//恢复按钮的原始状态
- (void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
//        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
      //  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
     
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.layer.borderWidth = 0;
     
        if (view.selectedIndex == i) {
            btn.selected = YES;
            btn.layer.borderColor = [UIColor redColor].CGColor;
       
            btn.layer.borderWidth = 1;
            self.ProductType = arr[i];
         
        }
    }
}


-(void)initMainView
{
    [self.buttonView addSubview:self.cancelButton];
    _cancelButton.sd_layout
    .rightSpaceToView(self.buttonView,KLeft)
    .topSpaceToView(self.buttonView,KLeft)
    .widthIs(40)
    .heightIs(40);
    
    NSDictionary * dict =  [self.goodModel.pictures  firstObject];
    [self.buttonView addSubview:self.goodImage];
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
    self.imageName =_goodImage;
    
    _goodImage.sd_layout
    .leftSpaceToView(self.buttonView,KLeft*1.5)
    .topSpaceToView(self.buttonView,-KLeft*2)
    .widthIs(100)
    .heightIs(100);
    

    //价格
    _priceLabel=[UILabel new];
    [_priceLabel setTextColor:[UIColor redColor]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.goodModel.shop_price];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(13) range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(18) range:NSMakeRange(1, self.goodModel.shop_price.length-1)];
    _priceLabel.attributedText = str;
   
    [self.buttonView addSubview:self.priceLabel];
    _priceLabel.sd_layout
    .leftSpaceToView(_goodImage,KLeft)
    .topSpaceToView(self.buttonView,KLeft*1.5)
    .heightIs(20)
    .widthIs(100);
    
    
    //库存
    _countLabel =[UILabel new];
    
    [_countLabel setFont:DefaultFontSize(15)];
    _countLabel.text =[NSString stringWithFormat:@"库存:%@", self.goodModel.goods_number] ;
    [self.buttonView addSubview:self.countLabel];
    _countLabel.sd_layout
    .leftEqualToView(_priceLabel)
    .topSpaceToView(_priceLabel,KLeft*1.5)
    .heightIs(20)
    .widthIs(150);
    
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.buttonView addSubview:line];
    line.sd_layout
    .leftSpaceToView(self.buttonView , 0)
    .rightSpaceToView(self.buttonView ,0)
    .topSpaceToView(_goodImage , KLeft)
    .heightIs(SINGLE_LINE_WIDTH);
    
    
    [self.buttonView addSubview:self.mainScrollView];
    
    _mainScrollView.sd_layout
    .leftSpaceToView(self.buttonView,0)
    .rightSpaceToView(self.buttonView,0)
    .topSpaceToView(line,0)
    .bottomSpaceToView(self.buttonView,44);
    
    CGFloat height = 0;
    
    if (self.goodModel.specification.count != 0) {
        [self.mainScrollView addSubview:self.sizeView];
        _sizeView.sd_layout
        .leftSpaceToView(self.mainScrollView,0)
        .rightSpaceToView(self.mainScrollView,0)
        .topSpaceToView(_mainScrollView,height)
        .heightIs(self.sizeView.typeViewHeight);
        
        height+= self.sizeView.typeViewHeight;
    }
    
    [self.mainScrollView addSubview:self.countView];
    _countView.sd_layout
    .leftSpaceToView(self.mainScrollView,0)
    .rightSpaceToView(self.mainScrollView,0)
    .topSpaceToView(_mainScrollView,height)
    .heightIs(50);
    
    //确定按钮
    [self.buttonView addSubview:self.sureButton];
    _sureButton.sd_layout
    .bottomSpaceToView(self.buttonView,0)
    .heightIs(44)
    .leftSpaceToView(self.buttonView,0)
    .rightSpaceToView(self.buttonView,0);

    
  }


-(void)sureButtonClick:(UIButton*)button
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(buttonMenuViewControllerDidCancel:andPushID:andType:andPoint:andImage:)]) {
        
        NSDictionary * dict = @{@"num":_good_count,@"type":self.ProductType};
        FLog(@"%@",dict);
        [self.delegate buttonMenuViewControllerDidCancel:nil andPushID:dict andType:self.actionType andPoint:CGPointMake(0, 0) andImage:self.imageName.image];
    }
  
}
-(void)banbenbuttonClick:(UIButton*)button
{
    if(button.tag != self.buttonTag)
    {
        UIButton * lastButton  =(UIButton*)[self.buttonBackgroundView viewWithTag:self.buttonTag];
        [lastButton setBackgroundColor:RGBACOLOR(249, 249, 249, 1)];
        
        [button setBackgroundColor:NavigationBackgroundColor];
        
        lastButton.selected =NO;
        button.selected =YES;
        
    }
    self.buttonTag = button.tag;
}
/**
 * 点击减按钮数量的减少
 *
 * @param sender 减按钮
 */
- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
    FLog(@"减按钮");

    int count =   [view.numberString intValue];
    if (count>5) {
        count -=5 ;
        view.numberString = [NSString stringWithFormat:@"%d",count];
        _good_count = view.numberString;
    }
}
/**
 * 点击加按钮数量的增加
 *
 * @param sender 加按钮
 */
- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
    FLog(@"加按钮");

    int count =   [view.numberString intValue];
 
        count +=5 ;
        view.numberString = [NSString stringWithFormat:@"%d",count];
        _good_count = view.numberString;
    
    
}
-(void)textFileBeginEditDelegate:(UITextField *)textField
{
    _good_count = textField.text;
    
    
    
}
-(void)textFileEndEditDelegate:(UITextField *)textField
{
     _good_count = textField.text;
    
}

#pragma mark - Presentation

- (void) showInView:(UIView*)view
{
    
    //  1. Hide the modal
    [[self modalView] setAlpha:0];
    
    //  2. Install the modal view
    [[view superview] addSubview:[self view]];
    
    _shrunkView = view;
    
    [[self view] setFrame:[[[self view] superview] bounds]];
    
    //  3. Show the buttons
    [[self buttonView] setTransform:CGAffineTransformMakeTranslation(0, [[self buttonView] frame].size.height)];
    
    //  4. Animate everything into place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
         [view setTransform:t];
         
         //  Fade in the modal
         [[self modalView] setAlpha:1.0];
         
         //  Slide the buttons into place
         [[self buttonView] setTransform:CGAffineTransformIdentity];
         
     }
     completion:^(BOOL finished) {
         _visible = YES;
     }];
    
}

- (void) hide
{
    
    //  2. Animate everything out of place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformIdentity;
         [_shrunkView setTransform:t];
         
         //  Fade in the modal
         [[self modalView] setAlpha:0.0];
         
         //  Slide the buttons into place
         
         t = CGAffineTransformTranslate(t, 0, [[self buttonView] frame].size.height);
         [[self buttonView] setTransform:t];
         
         
     }
     
     completion:^(BOOL finished) {
         [[self view] removeFromSuperview];
         _visible = NO;
         
     }];
    
}


@end

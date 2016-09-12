//
//  WriteCommentViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/26.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "WriteCommentViewController.h"
#import <CoreText/CoreText.h>
#import "CommunityTool.h"
@implementation WriteCommentViewController
#pragma mark - life Cycle
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor =NavigationBackgroundColor;
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:BackgroundColor];
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"写评价" andBack:@"icon_back.png" andRightName:@"提交"];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [self.view endEditing:YES];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lcNavigationController popViewController];
        });
    };
    NavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf.commentTextView resignFirstResponder];
        [weakSelf saveComment];
    };
    [self.view addSubview:NavigationView];
    [self.view addSubview:self.commentTextView];
    
    [self.view addSubview:self.rangLabel];
    _rangLabel .sd_layout
    .leftSpaceToView(self.view,KLeft+2)
    .topSpaceToView(_commentTextView,KLeft)
    .heightIs(40)
    .widthIs(70);
    
    
    [self.view addSubview:self.ratingView];
    [self starsSelectionChanged:_ratingView rating:5];
    _ratingView.sd_layout
    .rightSpaceToView(self.view,KLeft)
    .topEqualToView(_rangLabel)
    .widthIs(kScreenWidth/2)
    .heightIs(40);
}
#pragma mark - private methods
- (void)saveComment
{
    if ([_commentTextView.textColor isEqual:FontColor_gary]) {
        HUDSHOW(@"您还未输入评价内容");
    }
    else
    {
        [self postDataToServer];
    }
    
}
- (void)postDataToServer
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];

    [CommunityTool addComment:@"/comment/add" params:@{@"type":@"0",@"id":self.good_id,@"reply_id":@"",@"content":_commentTextView.text,@"rank":_ratingCount} success:^(id obj) {
        [hud hide:YES];
        HUDSHOW([obj objectForKey:@"message"]);
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.lcNavigationController popViewController];
        });
        
       
    } failure:^(id obj) {
         [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]]) {
               [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            
        }
        
    }];
}
#pragma mark - FKPTextView delegate
- (void)deleteBackward
{
    NSString *string = nil;
    NSString * inputString = _commeunityTextView.text;
    NSInteger stringLength = _commeunityTextView.text.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    _commeunityTextView.text =  string;
}

#pragma mark - UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.textColor isEqual:FontColor_gary]) {
        textView .text = @"";
        textView.textColor = FontColor_black;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _commeunityTextView.textColor = FontColor_gary;
        _commeunityTextView .text = @"请写下对产品的感受吧，对他人帮助很大哦";
    }
}
#pragma mark - EDStarRatingProtocol
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    _ratingCount = [NSString stringWithFormat:@"%f",rating];
}
#pragma mark - setter and getter
- (UILabel *)rangLabel
{
    if (!_rangLabel) {
        _rangLabel = [UILabel new];
        _rangLabel .textColor = FontColor_black;
        _rangLabel.font =  DefaultFontSize(16);
        _rangLabel .text = @"产品评分";
    }
    return _rangLabel;
}
- (EDStarRating *)ratingView
{
    if (!_ratingView) {
        _ratingView = [EDStarRating new];
        _ratingView.starImage = [UIImage imageNamed:@"CollectionNormal"];
        _ratingView.starHighlightedImage = [UIImage imageNamed:@"CollectionSelected"];
        _ratingView.maxRating = 5;
        _ratingView.delegate = self;
        _ratingView.editable = YES;
        _ratingView.rating = 5;
        _ratingView.displayMode = EDStarRatingDisplayFull;
        [_ratingView setBackgroundColor:[UIColor clearColor]];
        
        
    }
    return _ratingView;
}
- (FKPTextView *)commeunityTextView
{
    if(!_commeunityTextView)
    {
        _commeunityTextView =[[FKPTextView new] initWithFrame:CGRectMake(KLeft,kNavigationHeight+KLeft, kScreenWidth-KLeft*2, 200)];
        _commeunityTextView.delegate = self;
        _commeunityTextView.FkpDeleteDelegate=self;
        _commeunityTextView.text =@"请写下对产品的感受吧，对他人帮助很大哦";
        _commeunityTextView.delegate =self;
        _commeunityTextView.font = DefaultFontSize(14);
        _commeunityTextView.textColor = FontColor_gary;
        _isSystemBoardShow = NO;
        
    }
    return _commeunityTextView;
}
- (UITextView *)commentTextView
{
    if (!_commentTextView) {
        _commentTextView = [UITextView new];
        _commentTextView .delegate =self ;
        _commentTextView .font =  DefaultFontSize(14);
        _commentTextView .top = kNavigationHeight+KLeft;
        _commentTextView .left = KLeft;
        _commentTextView .width = kScreenWidth -KLeft*2;
        _commentTextView.height = 200;
        _commentTextView.textColor = FontColor_gary;
        _commentTextView .text = @"请写下对产品的感受吧，对他人帮助很大哦";
    }
    return _commentTextView;
}
@end

//
//  FKPScrollerView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/8.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PageControlStyle) {
    PageControlAtCenter,
    PageControlAtRight,
};
@interface FKPScrollerView : UIView <UIScrollViewDelegate>
{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UILabel *_leftLabel,*_centerLabel,*_rightLabel;
    
    __weak  UIScrollView *_scrollView;
    
    
    
    NSTimer *_timer;
    
    NSInteger _currentIndex;
    
    NSInteger _MaxImageCount;
    
    BOOL _isNetwork;
    
    BOOL _hasTitle;
}
@property (nonatomic ,strong)UIPageControl *PageControl;
@property (nonatomic,copy) NSArray *imageData;

@property (nonatomic,assign) NSTimeInterval AutoScrollDelay; //default is 2.0f,如果小于0.5不自动播放

//设置PageControl位置
@property (nonatomic,assign) PageControlStyle style; //default is PageControlAtCenter

@property (nonatomic,copy) NSArray<NSString *> *titleData; //设置后显示label,自动设置PageControlAtRight

//图片被点击会调用该block
@property (nonatomic,copy) void(^imageViewDidTapAtIndex)(NSInteger index); //index从0开始

/*@parameter imageUrl
 imageUrlString或imageName
 网络加载urlsring必须为http:// 开头,
 //本地加载只需图片名字数组
 */
+ (instancetype)picScrollViewWithFrame:(CGRect)frame WithImageUrls:(NSArray<NSString *> *)imageUrl;



@property (nonatomic,strong) UIColor *pageIndicatorTintColor;

@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;

//default is [[UIColor alloc] initWithWhite:0.5 alpha:1]
@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong) UIFont *font;

@end

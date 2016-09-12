//
//  tailorImageViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/21.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tailorImageViewController;
@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(tailorImageViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(tailorImageViewController *)cropperViewController;

@end

@interface tailorImageViewController : UIViewController
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;
@end

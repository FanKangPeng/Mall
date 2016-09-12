//
//  ViewController.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "ZWIntroductionViewController.h"
@interface ViewController : UIViewController

@property(nonatomic,strong) NSArray * tabTitleArr;
@property(nonatomic,strong)NSArray * tabIconArr;
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@property(nonatomic ,copy)void(^ViewCreateTabbarBlock)();
@property (nonatomic, strong) UIImageView *launchImage;
@end


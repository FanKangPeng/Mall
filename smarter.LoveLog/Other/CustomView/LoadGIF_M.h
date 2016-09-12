//
//  LoadGIF_M.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/12.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
@interface LoadGIF_M : UIView
{
    NSInteger  time;
}
@property(nonatomic,strong)NSTimer * timer;
@property (strong, nonatomic) DACircularProgressView *logo;

@end

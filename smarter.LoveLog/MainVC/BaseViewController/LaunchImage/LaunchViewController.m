//
//  LaunchViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "LaunchViewController.h"
#import "AFNetHttp.h"
#import "LaunchImage.h"
#import "RCDLoginInfo.h"
#import "AFNetHttp.h"
#import <RongIMKit/RongIMKit.h>

#define ContentType @"text/html"

@interface LaunchViewController ()

@end

@implementation LaunchViewController
#pragma mark - life  Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.launchImage];
    [self.view bringSubviewToFront:self.launchImage];
    _timeCount = 4;
   // [self.view addSubview:self.imageTitle];
    //    获得启动动画图片
    
     [self updateLanunchImage];
 
   
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
   
    [_timer invalidate];
    _timer = nil;
    _launchImage = nil;
    _Lb = nil;
    _timerBtn = nil;
    _timerLabel = nil;
    _timeCount = 0;
}
- (void)viewDidDisappear:(BOOL)animated
{
  
    [_timer invalidate];
    _timer = nil;
    _Lb = nil;
    _launchImage = nil;
     _timerLabel = nil;
    _timerBtn = nil;
    _timeCount = 0;
}
- (void)initUI
{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    self.launchImage.userInteractionEnabled = YES;
    [self.launchImage addGestureRecognizer:tap];
    [self.view addSubview:self.timerBtn];
    [_timerBtn addSubview:self.Lb];
    [_timerBtn addSubview:self.timerLabel];
    
    [self.timer fire];
}
- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"advertisement" object:_link_url];
}

#pragma mark - private method
- (void)updateLanunchImage{
    __WEAK_SELF_YLSLIDE
    

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 5.0f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
#ifdef ContentType
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
  
    
    NSString * url = [LoveLog_Host stringByAppendingString:@"/start"];
    
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError * err ;
        NSDictionary * dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if(err)
        {
            [self.view removeFromSuperview];
        }
        else 
        {
            LaunchImage *lanunchImage = [LaunchImage mj_objectWithKeyValues:[[dict objectForKey:@"data"] firstObject]];
            
            UIImage * cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:lanunchImage.img_url];
            if (cacheImage == nil) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:lanunchImage.img_url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    nil;
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             
                    if (image) {
                        
                        if (![lanunchImage.type isEqualToString:@"start"]) {
                            _link_url =lanunchImage.link_url;
                             [weakSelf initUI];
                        }
                        weakSelf.launchImage.image = image;
                        
                        [[SDImageCache sharedImageCache] storeImage:image forKey:lanunchImage.img_url];
                        
                        double delayInSeconds = 4.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [self.view removeFromSuperview];
                            //聊天登录
                            [[RCDLoginInfo shareLoginInfo] ChatLogin];
                            
                        });
                    }
                    else
                        [self.view removeFromSuperview];
                    
                }];
            }
            else
            {
                if (![lanunchImage.type isEqualToString:@"start"]) {
                    _link_url =lanunchImage.link_url;
                    [weakSelf initUI];
                }

                weakSelf.launchImage.image = cacheImage;
                double delayInSeconds = 4.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.view removeFromSuperview];
                    //聊天登录
                    [[RCDLoginInfo shareLoginInfo] ChatLogin];
                    
                });
            }

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view removeFromSuperview];
    }];

}
#pragma mark - NSTimer method
- (void)timerFire:(NSTimer*)timer
{
    _timeCount -= 1;
    _timerLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_timeCount];

    if (_timeCount <=0) {
        [self.view removeFromSuperview];
    }
}
- (void)skipButtonClick
{
    [self.view removeFromSuperview];
}
#pragma mark - getter and setter
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIImageView *)launchImage{
    
    if (_launchImage == nil) {
        _launchImage = [[UIImageView alloc] initWithFrame:kScreenBounds];
        _launchImage.image = [UIImage imageNamed:@"Default"];
    }
    
    return _launchImage;
}
- (UILabel *)Lb
{
    if (!_Lb) {
        _Lb = [UILabel new];
        _Lb .font = DefaultFontSize(14);
        _Lb.textColor = NavigationBackgroundColor;
        _Lb.frame =  CGRectMake(7, 0, 30, 25);
        _Lb.textAlignment = NSTextAlignmentRight;
        _Lb.text = @"跳过";
        
    }
    return _Lb;
}
- (UILabel *)timerLabel
{
    if (!_timerLabel) {
        _timerLabel = [UILabel new];
        _timerLabel.font = DefaultFontSize(15);
        _timerLabel.textColor = [UIColor whiteColor];
        _timerLabel.top = 0;
        _timerLabel.left = 39;
        _timerLabel.width= 20;
        _timerLabel.height =25;
        _timerLabel.text = @"3";
        _timerLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timerLabel;
}
- (UIButton *)timerBtn
{
    if (!_timerBtn) {
        _timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timerBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        _timerBtn.layer.masksToBounds =  YES;
        _timerBtn.layer.cornerRadius = 4;
        _timerBtn.titleLabel.font = DefaultFontSize(15);
        [_timerBtn setTitleColor:NavigationBackgroundColor forState:0];
        _timerBtn.frame  = CGRectMake(kScreenWidth - 70, 30, 55, 25);
        [_timerBtn addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerBtn;
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  NotReachView.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/24.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import "NotReachView.h"
#import "SetNetWorkingView.h"
@implementation NotReachView

+ (NotReachView *)shareInstance
{
    static NotReachView *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
    
}

-(instancetype)init
{
    self =[super initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
    if(self)
    {
        [self setBackgroundColor:BackgroundColor];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:BackgroundColor];
    }
    return self;

    
}
-(void)setError:( id)error
{
    [self initViewWithError:error];
}
-(void)initViewWithError:(id)error
{
    NSString * errorStr ;
    if([error isKindOfClass:[NSError class]])
    {
        NSError * err  =error;
        errorStr=  [err.userInfo objectForKey:@"NSLocalizedDescription"];
        if (errorStr.length <= 0) {
            errorStr=  [err.userInfo objectForKey:@"NSDebugDescription"];
        }
    }
    else
    {
        errorStr =[error objectForKey:@"error_desc"];
    }
    
   // DebugHud(errorStr);

    NSString * backImageName ;

    NSRange range = [errorStr rangeOfString:@"网络"];
     NSRange range1 = [errorStr rangeOfString:@"互联网"];
     NSRange range2 = [errorStr rangeOfString:@"数据"];
    if(range.length>0 ||range1.length>0)
    {
        self.frame =CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight);
        SetNetWorkingView * setnetview =[[SetNetWorkingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        setnetview.SetNetWorkingBlock=^{
            //跳转到设置
            
            NSURL*url =[NSURL URLWithString:@"prefs:root=Setting"];
            [[UIApplication sharedApplication] openURL:url];
            
        };
        [self addSubview:setnetview];
        backImageName =@"error_nowifi";
        
        
       // [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(netWorkRenew:) name:@"netWorkRenew" object:nil];
     
    }
    else if (range2.length>0)
    {
        backImageName =@"error_nodata";
    }
    else
        backImageName=@"error_default";
    
    UIImage * backImage  =[UIImage imageNamed:backImageName];
    
    UIImageView * imageView  =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-backImage.size.width/2, kNavigationHeight, backImage.size.width, backImage.size.height)];
    imageView.image= backImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
  
    
    imageView.center =CGPointMake( [UIApplication sharedApplication].keyWindow.center.x,[UIApplication sharedApplication].keyWindow.center.y/2);
    
    UIButton * reloadBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadBtn setFrame:CGRectMake(kScreenWidth/2-kWidth(60), imageView.bottom, kWidth(120), kWidth(40))];
    reloadBtn.layer.cornerRadius =kWidth(20);
    reloadBtn.layer.borderColor =ShiXianColor.CGColor;
    reloadBtn.layer.borderWidth =1;
    reloadBtn.layer.masksToBounds =YES;
    [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn setBackgroundColor:NavigationBackgroundColor];
    [reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:reloadBtn];

   
}
-(void)reloadBtnClick:(UIButton*)button
{
    _ReloadButtonBlock();
}


-(void)netWorkRenew:(NSNotification*)no
{
    _ReloadButtonBlock();
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

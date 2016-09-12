
#import "MyKeyChainHelper.h"
#ifndef Medical_Wisdom_UConstants_h
#define Medical_Wisdom_UConstants_h

/******************************************************/

/****  debug log **/ //NSLog输出信息

#ifdef DEBUG

#define FLog( s, ... ) NSLog( @"< %@:(%d) ----: %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define FLog( s, ... )

#endif


/***  DEBUG RELEASE  */

#if DEBUG

#define MCRelease(x)

#else

#define MCRelease(x)

#endif

/*****  release   *****/
#define NILRelease [x release], x = nil

#pragma mark - Frame(宏 x,y,width,height)

#define __WEAK_SELF_YLSLIDE     __weak typeof(self) weakSelf = self;
#define __STRONG_SELF_YLSLIDE   __strong typeof(weakSelf) strongSelf = weakSelf;

//获取系统版本号
#define iOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0

//判断设备类型
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6_6s  ([UIScreen mainScreen].bounds.size.width >= 375)

#define MainScreenScale [[UIScreen mainScreen]scale] //屏幕的分辨率 当结果为1时，显示的是普通屏幕，结果为2时，显示的是Retian屏幕
// App Frame Height&Width
#define Application_Frame  [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame
#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度
/*** MainScreen Height Width */
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define kScreenBounds [UIScreen mainScreen].bounds               //主屏幕bounds

//适配计算宽高

#define kWidth(R)  R * kScreenWidth /375
#define kHeight(R) (iPhone4?((R)*(kScreenHeight)/480):((R)*(kScreenHeight)/568))

// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

#define CONTRLOS_FRAME(x,y,width,height)     CGRectMake(x,y,width,height)

//    系统控件的默认高度
#define kStatusBarHeight   (20.f)
#define kTopBarHeight      (44.f)
#define kBottomBarHeight   (49.f)
#define kNavigationHeight  (64.f)

#define kCellDefaultHeight (44.f)
#define KLeft (10.f)

// 当控件为全屏时的横纵左边
#define kFrameX             (0.0)
#define kFrameY             (0.0)

#define kPhoneFrameWidth                 (320.0)
#define kPhoneWithStatusNoPhone5Height   (480.0)
#define kPhoneNoWithStatusNoPhone5Height (460.0)
#define kPhoneWithStatusPhone5Height     (568.0)
#define kPhoneNoWithStatusPhone5Height   (548.0)

#define kPadFrameWidth                   (768.0)
#define kPadWithStatusHeight             (1024.0)
#define kPadNoWithStatusHeight           (1004.0)



#define DesignHeight 1334.0
#define DesignWidth 750.0
#define GetWidth(width)  (width)/DesignWidth*kScreenWidth
//判断是不是4s如果是则高度和5s一样的比例
#define GetHeight(height) (kScreenHeight > 568 ? (height)/DesignHeight*kScreenHeight : (height)/DesignHeight*568)

//中英状态下键盘的高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#pragma mark - Funtion Method (宏 方法)
//PNG JPG 图片路径
#define PNGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME,EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

//加载图片
#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define ImageName(Name)         [UIImage imageNamed:Name]


// 角度和弧度转换

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)
//判断系统版本
#define OpinionVesion   __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_2

//字体大小（常规/粗体）
#define DefaultBoldFontSize(FONTSIZE)  OpinionVesion ?[UIFont systemFontOfSize:FONTSIZE+FontSizeValue(0) weight:UIFontWeightBold]:[UIFont fontWithName:@"CourierNewPSMT" size:FONTSIZE+FontSizeValue(0)]
#define DefaultFontSize(FONTSIZE)      OpinionVesion ?[UIFont systemFontOfSize:FONTSIZE+FontSizeValue(0) weight:UIFontWeightLight]:[UIFont fontWithName:@"CourierNewPSMT" size:FONTSIZE+FontSizeValue(0)]
#define FontNameAndSize(NAME,FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]
//适配字号


#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//当前版本
#define FSystenVersion            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])

//当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])


//是否Retina屏
#define isRetina                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)
//是否iPhone5
#define ISIPHONE                  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISIPHONE5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是iPad
#define isPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// UIView - viewWithTag 通过tag值获得子视图
#define VIEWWITHTAG(_OBJECT,_TAG)   [_OBJECT viewWithTag : _TAG]

//应用程序的名字
#define AppDisplayName              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

//keyChain - sessionkey
#define KeyChain_SessionKey  @"com.smarte.LoveLog.session"

//RGB颜色转换（16进制->10进制）
//十六进制颜色

#define GetColor(hexColor)\
[UIColor colorWithRed((hexColor >> 16)&0xFF)/255.0\
green:((hexColor >>8)&0xFF)/255.0\
blue:((hexColor>>0)&0xFF)/255.0\
alpha:((hexColor >>24)&0xFF)/255.0]

//全局颜色以及宽高的宏定义

#define SINGLE_LINE_WIDTH  (1/[UIScreen mainScreen].scale) // ((int)( (1/[UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) + 1) % 2 == 0   ? (1/[UIScreen mainScreen].scale)/2 : (1/[UIScreen mainScreen].scale)

#define SINGLE_LINE_ADJUST_OFFSET ((1.0f/[UIScreen mainScreen].scale) / 2)
#define MainBobyColor [UIColor colorWithRed:254.00/255.00 green:214.00/255.00 blue:82.00/255.00 alpha:1]
#define NavigationBackgroundColor [UIColor colorWithRed:252.00/255.00 green:19.00/255.00 blue:89.00/255.00 alpha:1]
#define BackgroundColor [UIColor colorWithRed:240.00/255.00 green:240.00/255.00 blue:240.00/255.00 alpha:1]
#define transparentColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define ShiXianColor [UIColor colorWithRed:229.00/255.00 green:229.00/255.00 blue:229.00/255.00 alpha:1]
#define FontColor_black [UIColor colorWithRed:51.00/255.00 green:51.00/255.00 blue:51.00/255.00 alpha:1]
#define FontColor_gary [UIColor colorWithRed:102.00/255.00 green:102.00/255.00 blue:102.00/255.00 alpha:1]
#define FontColor_lightGary [UIColor colorWithRed:133.00/255.00 green:133.00/255.00 blue:133.00/255.00 alpha:1]
#define FontColor_red [UIColor colorWithRed:241.00/255.00 green:83.00/255.00 blue:83.00/255.00 alpha:1]

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)



//NSUSerDefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//密码检索
#define IS_A_PASSWORLD(senderString) ({   NSString * regex = @"^[A-Za-z0-9]{6,15}$";  \
NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];      \
([pred evaluateWithObject:senderString])? YES : NO ;                                  \
})
//手机号检索
#define IS_USERNAME(senderString)({   NSString *pattern = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";   \
NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern]; \
([pred evaluateWithObject:senderString])? YES : NO;                                  \
})

//邮编检索
#define IS_POSTCODE(senderString)({   NSString *pattern = @"[1-9]\\d{5}(?!\\d)";   \
NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern]; \
([pred evaluateWithObject:senderString])? YES : NO;                                  \
})

//判断设备室真机还是模拟器
#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif
//mbprogresshud with view
#define HUDVIEW(string,view)({ \
    MBProgressHUD*  HUD = [[MBProgressHUD alloc] initWithView:view];\
    [view addSubview:HUD];\
    HUD.mode = MBProgressHUDModeText;\
    HUD.color  =FontColor_gary;\
    HUD.labelText = string;\
    HUD.labelFont = DefaultFontSize(14);\
    HUD.yOffset = kScreenHeight/3;\
    [HUD show:YES];\
    [HUD hide:YES afterDelay:1];\
})

//mbprogresshud
#define HUDSHOW(string)({ \
        \
    MBProgressHUD*  HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window.rootViewController.view];\
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:HUD];\
    HUD.mode = MBProgressHUDModeText;\
    HUD.color  =FontColor_gary;\
    HUD.labelText = string;\
    HUD.labelFont = DefaultFontSize(14);\
    HUD.yOffset = kScreenHeight/3;\
    [HUD show:YES];\
    [HUD hide:YES afterDelay:1];\
})

#if DEBUG
#define DebugHud(string)({ \
    \
    MBProgressHUD*  HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window.rootViewController.view];\
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:HUD];\
    HUD.mode = MBProgressHUDModeText;\
    HUD.color  =FontColor_gary;\
    HUD.labelText = string;\
    HUD.labelFont = DefaultFontSize(14);\
    HUD.yOffset = kScreenHeight/3;\
    [HUD show:YES];\
    [HUD hide:YES afterDelay:3];\
})
#endif
//登录状态
#define isLogin loginType()

#endif





static inline  int FontSizeValue(CGFloat height)
{
    if(iPhone6plus)
        return 0;
    else if(iPhone6)
        return 0;
    else
        return -1;
}

static inline BOOL loginType()
{
    NSDictionary * dict = [MyKeyChainHelper getSession:KeyChain_SessionKey];
    if (dict.allValues.count >0) {
        return true;
    }
    else
        return false;
}




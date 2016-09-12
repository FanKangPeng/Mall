//
//  UserInfoCenterHeadView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/4.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "UserInfoCenterHeadView.h"
#import "MyKeyChainHelper.h"
#import "UserInfoTool.h"

@implementation UserInfoCenterHeadView
-(void)setUserInfo:(UserInfoModel *)userInfo
{
    _userInfo =userInfo;
    
    UIImage * image;
   
    if (isLogin) {
        self.nameLabel.hidden= NO;
        image =  [UIImage imageNamed:@"userInfo_portrait_icon.jpg"];
    }
    else
    {
        self.nameLabel.hidden= YES;
        image = [UIImage imageNamed:@"userInfo_portrait_unLogin_icon"];
    }
            
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:image];

    self.nameLabel.text = userInfo.name;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];

    self.contentMode =UIViewContentModeScaleAspectFill;
    [self setImage:[UIImage imageNamed:@"userInfo_top_BackImage.jpg"]];
    self.userInteractionEnabled = YES;
    self.autoresizesSubviews = YES;

    UIView  * quanquan  =[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-self.frame.size.height/4-4,self.frame.size.height/4-4,self.frame.size.height/2+8,self.frame.size.height/2+8)];
    quanquan.layer.cornerRadius = quanquan.width/2;
    
    quanquan.layer.borderColor = [[UIColor colorWithRed:255/255.00 green:255/255.00 blue:255/255.00 alpha:0.4] CGColor];
    quanquan.layer.borderWidth = 4.0f;
    quanquan.autoresizingMask =UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:quanquan];
    
    [quanquan addSubview:self.portraitImageView];
    
    [self addSubview:self.nameLabel];

    UIButton * setBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.autoresizingMask =UIViewAutoresizingFlexibleTopMargin;
    [setBtn setFrame:CGRectMake(kScreenWidth-44, 20, 44, 44)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"userInfo_icon_set.png"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:setBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:@"updateUserInfo" object:nil];
    
    return self;
}
- (void)updateUserInfo
{
        _nameLabel.text = self.cacheUserInfo.name;
        [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.cacheUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"userInfo_portrait_unLogin_icon"]];
    
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50,self.frame.size.height/4*3, 100, kHeight(30))];
        _nameLabel.autoresizingMask =UIViewAutoresizingFlexibleTopMargin;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = DefaultFontSize(16);
        _nameLabel.text = self.cacheUserInfo.name;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UIImageView *)portraitImageView
{
    if(!_portraitImageView)
    {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3,self.frame.size.height/2+2,self.frame.size.height/2+2)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        
        [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.cacheUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"userInfo_portrait_unLogin_icon"]];
        UITapGestureRecognizer * tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:tp];
    
    }
    return _portraitImageView;
}
- (UserInfoModel *)cacheUserInfo
{
        NSData *data = [NSMutableData dataWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoModel"]];
        if (data.length>0) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"userInfoModel"];
            _cacheUserInfo =[UserInfoModel mj_objectWithKeyValues:myDictionary];
        }
    return _cacheUserInfo;
}
#pragma mark - _portraitImageView
- (void)editPortrait {
    NSDictionary * session = [MyKeyChainHelper getSession:KeyChain_SessionKey];
    if (session.allKeys.count<=0) {

         _LoginButtonBlock();
    }
    else
    {
        _PortraitImageViewBlock();
    }
}

-(void)setBtnClick:(UIButton*)button
{
    _SetButtonBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

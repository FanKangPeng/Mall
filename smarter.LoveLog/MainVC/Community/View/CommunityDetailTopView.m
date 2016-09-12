//
//  CommunityDetailTopView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/30.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityDetailTopView.h"


#import "UserInfoModel.h"
@implementation CommunityDetailTopView
-(instancetype)initWithFrame:(CGRect)frame
{
     self =[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.posterImageView];

        
        [self addSubview:self.titleLable];
        _titleLable.sd_layout
        .leftSpaceToView(self,KLeft)
        .rightSpaceToView(self,KLeft)
        .topSpaceToView(_posterImageView,KLeft)
        .heightIs(30);
        
        [self addSubview:self.portraitImageView];
        _portraitImageView.sd_layout
        .leftSpaceToView(self,KLeft)
        .topSpaceToView(_titleLable,10)
        .widthIs(35)
        .heightIs(35);
        
        
        [self addSubview:self.nameLabel];
        _nameLabel.sd_layout
        .leftSpaceToView(_portraitImageView,10)
        .topSpaceToView(_titleLable,20)
        .widthIs(200)
        .heightIs(20);
        
        [self addSubview:self.timeLabel];
        _timeLabel.sd_layout
        .rightSpaceToView(self,KLeft)
        .topEqualToView(_nameLabel)
        .heightIs(20);
        
        
    }
    return self;
}
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(KLeft),KLeft,35,35)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleToFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _portraitImageView.layer.shadowOpacity = 0;
        _portraitImageView.layer.shadowRadius = 0;
        _portraitImageView.layer.borderColor =[UIColor whiteColor].CGColor;
        _portraitImageView.layer.borderWidth = 1;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor =  [UIColor whiteColor];
    }
    return _portraitImageView;
}
- (UIImageView *)posterImageView
{
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/9*5)];
        [_posterImageView setImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
    }
    return _posterImageView;
}
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font =DefaultBoldFontSize(17);
        _titleLable.textColor = FontColor_black;
        _titleLable.numberOfLines=0;
        _titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _titleLable;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font =DefaultFontSize(15);
        _nameLabel.textColor =FontColor_black;
        
    }
    return _nameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font =DefaultFontSize(13);
        _timeLabel.textAlignment =  NSTextAlignmentRight;
        _timeLabel.textColor =FontColor_lightGary;
    }
    return _timeLabel;
}
-(void)setCommunityDeatilModel:(CommunityDetailModel *)communityDeatilModel
{

    [self setBackgroundColor:[UIColor whiteColor]];
    
    NSString * imageUrl =[communityDeatilModel.img objectForKey:@"cover"];

    
    __block MBProgressHUD * HUD;
      __weak UIImageView *weakImageView = _posterImageView;
    __WEAK_SELF_YLSLIDE
    [_posterImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        MAIN(^{
            if (!HUD) {
                HUD =[[MBProgressHUD alloc] initWithView:weakImageView];
                [weakImageView addSubview:HUD];
                HUD.delegate = weakSelf;
                HUD.color = [UIColor clearColor];
                
                [HUD show:YES];
            }
            [weakSelf showProgerssWithReceivedSize:receivedSize andexpectedSize:expectedSize andHUd:HUD];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [ HUD hide:YES];
    }];
    
    UserInfoModel * userInfo = [UserInfoModel mj_objectWithKeyValues:communityDeatilModel.user];
    
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:communityDeatilModel.title];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:9];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [communityDeatilModel.title length])];
    [_titleLable setAttributedText:attributedString1];
    CGSize size = [_titleLable sizeThatFits:CGSizeMake(kScreenWidth-KLeft*2, MAXFLOAT)];
    _titleLable.sd_layout
    .leftSpaceToView(self,KLeft)
    .rightSpaceToView(self,KLeft)
    .topSpaceToView(_posterImageView,KLeft)
    .heightIs(size.height);

    
    
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
  
    _nameLabel.text=userInfo.name;

    _timeLabel.text=communityDeatilModel.add_time;
    
    
   
    self.height = _posterImageView.height + _titleLable.height + _nameLabel.height + KLeft;
    FLog(@"%f",self.height);
   
}
-(void)showProgerssWithReceivedSize:(NSInteger)receivedSize andexpectedSize:(NSInteger)expectedSize andHUd:(MBProgressHUD*)HUD
{
    float showProgress = (float)receivedSize/(float)expectedSize;
    [HUD setProgress:showProgress];
    if(showProgress >=1)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}


@end

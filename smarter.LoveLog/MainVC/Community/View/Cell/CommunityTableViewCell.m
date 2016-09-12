//
//  CommunityTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/18.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityTableViewCell.h"
#import "UserInfoModel.h"
#import "CommunityTool.h"
#import "CustomAlertView.h"
#import "ShareManager.h"
@implementation CommunityTableViewCell

- (void)awakeFromNib {
   
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         [self setBackgroundColor:[UIColor whiteColor]];
        [self initView];
    }
    return self;
}
#pragma mark - setCommunityModel
-(void)setCommunityModel:(CommunityModel *)communityModel
{
    _communityModel = communityModel;
    UserInfoModel * userModel = [UserInfoModel mj_objectWithKeyValues:communityModel.user];
    
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:[UIImage imageNamed:@"userInfo_portrait_icon.jpg"] options:SDWebImageRetryFailed];
    if([communityModel.is_best isEqualToString:@"1"])
    {
        self.Essence.hidden =NO;
    }
    else
    {
        self.Essence.hidden =YES;
    }
    
    if([communityModel.is_hot isEqualToString:@"1"])
    {
        self.hot.hidden =NO;
    }
    else
    {
        self.hot.hidden =YES;
    }
    
    
    self.nameLabel.text = userModel.name;
    
    self.timeLabel.text = communityModel.add_time;
  
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:communityModel.title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:9];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [communityModel.title length])];
    [self.titleLabel setAttributedText:attributedString];
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(kScreenWidth-30, MAXFLOAT)];
  
    _titleLabel.sd_layout
    .heightIs(kWidth(size.height))
    .widthIs(size.width);
    
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:communityModel.brief];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:9];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [communityModel.brief length])];
    [self.contentLable setAttributedText:attributedString1];
    
    CGSize size1 = [_contentLable sizeThatFits:CGSizeMake(kScreenWidth-KLeft*2, MAXFLOAT)];

    _contentLable.sd_layout
    .widthIs(size1.width)
    .heightIs(size1.height);
    
    
    _imageArr =[NSMutableArray array];
    
    NSDictionary * imageDict =communityModel.img;
    NSMutableArray * imageArray =[NSMutableArray array];
  
    NSString * value1 =[imageDict objectForKey:@"cover"];
   
    if(value1.length >0)
    {
        [imageArray addObject:value1];
    }
    
    CGFloat imageHeight= kScreenWidth/9*5;
    
    for (int i  =0 ; i<imageArray.count; i++) {
        //固定宽高比1.8：1
         UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,(10+imageHeight)*i,kScreenWidth,imageHeight)];
        __block MBProgressHUD * HUD;
        __weak UIImageView *weakImageView = imageView;
        
        UIImage * cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageArray[i]];
        if (cacheImage) {
            imageView.image = cacheImage;
        }
        else
        {
            __WEAK_SELF_YLSLIDE
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]  options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
                if(image)
                {
                    [ HUD hide:YES];
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageArray[i]];
                    
                }
            }];
        }
        
        [_imageArr addObject:imageView];
        
        [self.imageBacgroundkView addSubview:imageView];
    }
     
    
  
    
    
    self.imageBacgroundkView.sd_layout
    .heightIs(imageHeight*imageArray.count+(imageArray.count-1)*10);
    
 
    [self.loveButton setTitle:communityModel.like_count forState:UIControlStateNormal];
    [_loveButton setImage:[UIImage imageNamed:@"IMG_PostDetail_zan"] forState:UIControlStateNormal];
    [_loveButton setImage:[UIImage imageNamed:@"IMG_PostDetail_yizanPress"] forState:UIControlStateSelected];
    if([communityModel.is_like isEqualToString:@"1"])
    {
        self.loveButton.selected=YES;
    }
    else
        self.loveButton.selected = NO;
    
    CGSize strSize = [communityModel.like_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(15)}];

    _loveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [_loveButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _loveButton.width-20)];
     [_loveButton setTitleEdgeInsets:UIEdgeInsetsMake(20-strSize.height,4, 0, 0)];
    
    
    
    
    
    [_commentButton setImage:[UIImage imageNamed:@"IMG_PostDetail_cmt"] forState:UIControlStateNormal];
    [self.commentButton setTitle:communityModel.cmt_count forState:UIControlStateNormal];
     CGSize commentButtonSize = [communityModel.cmt_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(15)}];
    _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, _commentButton.width-20)];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(20-commentButtonSize.height,4, 0, 0)];
    
    
   
    
    
     [self setupAutoHeightWithBottomView:_bottonView bottomMargin:0];
   
}
#pragma mark - setter and getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(KLeft), kWidth(KLeft),kWidth(40),kWidth(40))];
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
-(UIButton *)Essence
{
    if(!_Essence)
    {
        _Essence =[UIButton buttonWithType:UIButtonTypeCustom];
        _Essence.frame  = CGRectMake(kScreenWidth-kWidth(70), 0, kWidth(25), kWidth(39));
        [_Essence setBackgroundImage:[UIImage imageNamed:@"community_essence"] forState:UIControlStateNormal];
        [_Essence setTitle:@"精\n华" forState:UIControlStateNormal];
        _Essence.titleLabel.font =DefaultFontSize(13);
        _Essence.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _Essence.userInteractionEnabled =NO;
    }
    return _Essence;
}
-(UIButton *)hot
{
    if(!_hot)
    {
        _hot =[UIButton buttonWithType:UIButtonTypeCustom];
        _hot .frame  =CGRectMake(kScreenWidth-kWidth(35), 0, kWidth(25), kWidth(39));
        [_hot setBackgroundImage:[UIImage imageNamed:@"community_hot"] forState:UIControlStateNormal];
        [_hot setTitle:@"热\n门" forState:UIControlStateNormal];
        _hot.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _hot.titleLabel.font =DefaultFontSize(13);
        _hot.userInteractionEnabled =NO;
    
    }
    return _hot;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel =[[UILabel alloc] init];
        _nameLabel.textColor = FontColor_black;
        _nameLabel.font=DefaultFontSize(13);
    }
    return _nameLabel;
}
-(UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel  =[[UILabel alloc] init];
        _timeLabel.textColor =FontColor_lightGary;
        _timeLabel.font =DefaultFontSize(12);
    }
    return _timeLabel;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel =[[UILabel alloc] init];
        _titleLabel.textColor =FontColor_black;
        _titleLabel.font=DefaultFontSize(15);
        _titleLabel.numberOfLines=0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_titleLabel sizeToFit];
        _titleLabel.textAlignment =NSTextAlignmentLeft;
    }
    return _titleLabel;
}
-(UILabel *)contentLable
{
    if(!_contentLable)
    {
        _contentLable =[[UILabel alloc] init];
        _contentLable.textColor=FontColor_lightGary;
        _contentLable.textAlignment=NSTextAlignmentLeft;
        _contentLable.font=DefaultFontSize(13);
        [_contentLable setLineBreakMode:NSLineBreakByWordWrapping];
        _contentLable.numberOfLines=0;
    }
    return _contentLable;
}
-(UIView *)imageBacgroundkView
{
    if(!_imageBacgroundkView)
    {
        _imageBacgroundkView =[UIView new];
        [_imageBacgroundkView setBackgroundColor:[UIColor clearColor]];
        
    }
    return _imageBacgroundkView;
}
-(UIButton *)loveButton
{
    if(!_loveButton)
    {
        _loveButton.frame = CGRectMake(KLeft,kBottomBarHeight/2-5, 60, 10);
        _loveButton =[UIButton buttonWithType:UIButtonTypeCustom];
  
   
        [_loveButton addTarget:self action:@selector(loveViewTapClick) forControlEvents:UIControlEventTouchUpInside];
       
        _loveButton.titleLabel.font =DefaultFontSize(15);
        [_loveButton setTitleColor:FontColor_gary forState:UIControlStateNormal];
        
    }
    return _loveButton;
}
-(UIButton *)commentButton
{
    if(!_commentButton)
    {
        _commentButton =[UIButton buttonWithType:UIButtonTypeCustom];
     
  
        [_commentButton addTarget:self action:@selector(commentViewTapClick) forControlEvents:UIControlEventTouchUpInside];
    
        _commentButton.titleLabel.font =DefaultFontSize(15);
        [_commentButton setTitleColor:FontColor_gary forState:UIControlStateNormal];
    }
    return _commentButton;
    
}
-(UIButton *)shareButton
{
    if(!_shareButton)
    {
        _shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"ShareNormal"] forState:UIControlStateNormal];
      
        [_shareButton addTarget:self action:@selector(shareViewTapClick) forControlEvents:UIControlEventTouchUpInside];
        
        _shareButton.titleLabel.font =DefaultFontSize(13);
        [_shareButton setTitleColor:FontColor_gary forState:UIControlStateNormal];
     
    }
    return _shareButton;
}
-(UIButton *)awardButton
{
    if(!_awardButton)
    {
        _awardButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_awardButton setBackgroundImage:[UIImage imageNamed:@"community_award"] forState:UIControlStateNormal];
        [_awardButton addTarget:self action:@selector(awardViewTapClick:witheven:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _awardButton;
}
-(UIView *)bottonView
{
    if(!_bottonView)
    {
        _bottonView =[UIView new];
        [_bottonView setBackgroundColor:[UIColor whiteColor]];
        [_bottonView addSubview:self.loveButton];
        _loveButton.sd_layout
        .leftEqualToView(_portraitImageView)
        .topSpaceToView(_bottonView,10)
        .heightIs(20)
        .widthIs(50);
        
        [_bottonView addSubview:self.commentButton];
        _commentButton.sd_layout
        .leftSpaceToView(_loveButton,0)
        .topEqualToView(_loveButton)
        .heightIs(20)
        .widthIs(50);
        
        [_bottonView addSubview:self.shareButton];
        _shareButton.sd_layout
        .leftSpaceToView(_commentButton,0)
        .topEqualToView(_loveButton)
        .widthIs(50)
        .heightIs(20);
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        CGSize shareButtonSize = [@"分享" sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(13)}];
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, _shareButton.width-20)];
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(20-shareButtonSize.height,4, 0, 0)];
        
        
        
        [_bottonView addSubview:self.awardButton];
        _awardButton.sd_layout
        .leftSpaceToView(_bottonView,kScreenWidth-kWidth(15)-52)
        .topEqualToView(_loveButton)
        .heightIs(20)
        .widthIs(52);
    }
    
    return _bottonView;
}
#pragma mark - initUI
-(void)initView
{
    [self.contentView addSubview:self.portraitImageView];
    
    [self.contentView addSubview:self.Essence];
    [self.contentView addSubview:self.hot];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];
    self.nameLabel.sd_layout
    .leftSpaceToView(self.portraitImageView,KLeft)
    .topSpaceToView(self.contentView,kWidth(KLeft+2))
    .heightIs(kWidth(20))
    .widthIs(kScreenWidth-self.portraitImageView.right-kWidth(85));
    
    [self.contentView addSubview:self.timeLabel];
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_portraitImageView,-15)
    .heightIs(15)
    .widthIs(kScreenWidth-self.portraitImageView.right-kWidth(85));
    
    [self.contentView addSubview:self.titleLabel];
    _titleLabel.sd_layout
    .leftEqualToView(_portraitImageView)
    .topSpaceToView(_portraitImageView,kWidth(KLeft));
    
    
    [self.contentView addSubview:self.contentLable];
    _contentLable.sd_layout
    .leftEqualToView(_portraitImageView)
    .topSpaceToView(_titleLabel,KLeft);
    
    [self.contentView addSubview:self.imageBacgroundkView];
    _imageBacgroundkView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_contentLable,KLeft)
    .widthIs(kScreenWidth);
    
    [self.contentView addSubview:self.bottonView];
    _bottonView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_imageBacgroundkView,0)
    .widthIs(kScreenWidth)
    .heightIs(40);
  
   
}


#pragma mark - private methods
-(void)loveViewTapClick
{
 
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [CommunityTool likeCommunity:@"/digg" params:@{@"id":self.communityModel.id,@"type":@"2"} success:^(id obj) {
        [hud hide:YES];
        [self changeCollectButton:obj];
    } failure:^(id obj) {
        [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {

           
         if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
             self.commentLoginBlock();
             
            }
            else
            {
                 HUDSHOW([obj objectForKey:@"error_desc"]);
            }
         
            
        }
 

    }];
}
-(void)changeCollectButton:(id)obj
{
    _loveButton.selected=YES;
    
    [_loveButton setTitle:[NSString stringWithFormat:@"%@",[obj objectForKey:@"like_count"]] forState:UIControlStateNormal];
}

-(void)commentViewTapClick
{
    _commentBlock(_communityModel.id);
}
-(void)shareViewTapClick
{
    [[ShareManager sharedInstance] createShareContentWithShareDict:self.communityModel.share andShareView:self];
}
-(void)awardViewTapClick:(UIButton*)tap witheven:(UIEvent*)even
{
    [[Award sharedInstance] awardViewTapClick:tap witheven:even];
   __WEAK_SELF_YLSLIDE
    [Award sharedInstance].AwardBlock=^(NSString *rewardCount) {
      
        weakSelf.rewardCount =rewardCount;
       CustomAlertView * alert =  [[CustomAlertView alloc] initWithTitle:[NSString stringWithFormat:@"此次打赏需消耗您%@",rewardCount] message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        alert.delegate =self;
        alert.tag =100;
        [alert show];
    };
        
   
}
-(void)rewardCommunity:(NSString*)rewardCount
{
    NSDictionary * dict =@{@"reward":rewardCount,@"post_id":self.communityModel.id};
    
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    [CommunityTool rewardCommunity:@"/post/reward" params:dict success:^(id obj) {
        [hud hide:YES];
        
        HUDSHOW(@"打赏成功");
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[Award sharedInstance] awardSuccess];
        });
        
        
    } failure:^(id obj) {
        [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[Award sharedInstance] awardFailer];
            });
        }
        else
        {
            
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                
                [[Award sharedInstance] awardFailer];
                self.commentLoginBlock();
                
               

                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [[Award sharedInstance] awardFailer];
                });
                
            }
            
        }
    }];
}
#pragma mark - CustomAlertView delegate
-(void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex ==0)
        {
            [customAlertView hide];
        }
        else
        {
              [self rewardCommunity:self.rewardCount];
        }

}

#pragma mark - MBProgressHUD delegate
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

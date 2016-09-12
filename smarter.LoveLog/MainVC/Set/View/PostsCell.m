//
//  PostsCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "PostsCell.h"

@implementation PostsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView * view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KLeft)];
        [view setBackgroundColor:BackgroundColor];
        [self.contentView addSubview:view];
        [self initView];
    }
    return self;
}

-(void)setCommunityModel:(CommunityModel *)communityModel
{
    _communityModel = communityModel;
 
    NSDictionary * imageDict =communityModel.img;
    NSMutableArray * imageArray =[NSMutableArray array];
    
    NSString * value1 =[imageDict objectForKey:@"cover"];
    
    if(value1.length >0)
    {
        [imageArray addObject:value1];
    }
    
    CGFloat imageHeight=(kScreenWidth-KLeft*2)/9*5;

    for (int i  =0 ; i<imageArray.count; i++) {
        //固定宽高比1.8：1
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,(10+imageHeight)*i,kScreenWidth-KLeft*2,imageHeight)];
        __block MBProgressHUD * HUD;
        __weak UIImageView *weakImageView = imageView;
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
                
            }
        }];
        [self.imageBacgroundkView addSubview:imageView];
    }
    
    self.imageBacgroundkView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,KLeft)
    .rightSpaceToView(self.contentView,0)
    .heightIs(imageHeight*imageArray.count+(imageArray.count-1)*10);

    self.titleLabel.text =communityModel.title;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*4, MAXFLOAT)];
    [self.titleLabel sizeToFit];
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(_imageBacgroundkView,KLeft)
    .heightIs(size.height)
    .widthIs(size.width);
    
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:communityModel.brief];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:9];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [communityModel.brief length])];
    [self.contentLable setAttributedText:attributedString1];
    [self.contentLable sizeToFit];
    
    CGSize size1 = [_contentLable sizeThatFits:CGSizeMake(kScreenWidth-KLeft*4, MAXFLOAT)];
    _contentLable.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,KLeft)
    .widthIs(size1.width)
    .heightIs(size1.height);
    
   
    _backView.sd_layout
    .topSpaceToView(_contentLable,KLeft);
   
    
    self.timeLabel.text = communityModel.add_time;
   
    
    
    
    
    [_commentButton setImage:[UIImage imageNamed:@"community_commont"] forState:UIControlStateNormal];
    [self.commentButton setTitle:communityModel.cmt_count forState:UIControlStateNormal];
    CGSize commentButtonSize = [communityModel.cmt_count sizeWithAttributes:@{NSFontAttributeName:DefaultFontSize(15)}];
    _commentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(kWidth(4), 0, kWidth(4), _commentButton.width-kWidth(15))];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-commentButtonSize.width, 0, KLeft)];
    
    
    
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];
    
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

-(UIView *)backView
{
    if (!_backView) {
        _backView =[[UIView alloc] init];
        [_backView setBackgroundColor:[UIColor clearColor]];
        
        
        
        
        [_backView addSubview:self.timeLabel];
        _timeLabel.sd_layout
        .topSpaceToView(_backView,KLeft)
        .leftSpaceToView(_backView,KLeft)
        .widthIs(kScreenWidth/2)
        .heightIs(20);
   
        
        [_backView addSubview:self.commentButton];
        _commentButton.sd_layout
        .rightSpaceToView(_backView,KLeft)
        .topEqualToView(_timeLabel)
        .heightIs(20)
        .widthIs(50);
        
    }
    return _backView;
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
        _imageBacgroundkView =[[UIView alloc] init];
        [_imageBacgroundkView setBackgroundColor:[UIColor clearColor]];
        
    }
    return _imageBacgroundkView;
}

-(UIButton *)commentButton
{
    if(!_commentButton)
    {
        _commentButton =[UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [_commentButton addTarget:self action:@selector(commentViewTapClick) forControlEvents:UIControlEventTouchDown];
        
        _commentButton.titleLabel.font =DefaultFontSize(15);
        [_commentButton setTitleColor:FontColor_gary forState:UIControlStateNormal];
    }
    return _commentButton;
    
}

-(void)commentViewTapClick
{
    _PostsCellBlock(self.communityModel.id);
}
-(void)initView
{
    [self.contentView  addSubview:self.imageBacgroundkView];
    
    
    [self.contentView  addSubview:self.titleLabel];
    
    
    [self.contentView  addSubview:self.contentLable];

    [self.contentView addSubview:self.backView];
    _backView.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .rightSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentLable,KLeft)
    .heightIs(40);

}
@end

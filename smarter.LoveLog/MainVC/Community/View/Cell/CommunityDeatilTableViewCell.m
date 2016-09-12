//
//  CommunityDeatilTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/10.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "CommunityDeatilTableViewCell.h"

#import "ShareManager.h"
#import "UserInfoModel.h"
@implementation CommunityDeatilTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)setCommunityDeatilModel:(CommunityDetailModel *)communityDeatilModel
{
    CGFloat scrollView_height;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    NSDictionary * imageDict =communityDeatilModel.img;
    NSMutableArray * imageViewArr =[NSMutableArray array];
    
    NSString * value1 =[imageDict objectForKey:@"cover"];
    NSString * value2 =[imageDict objectForKey:@"thumb"];
    if(value1.length >0)
    {
        [imageViewArr addObject:value1];
    }
    
    if(value2.length>0)
    {
        [imageViewArr addObject:value2];
    }
    imageArr =[NSMutableArray array];
    for (int i =0; i<imageViewArr.count; i++) {
        UIImageView * image1=[[UIImageView alloc] initWithFrame:CGRectMake(0,scrollView_height,kScreenWidth,kScreenWidth*0.44)];
        __block MBProgressHUD * HUD;
        __weak UIImageView *weakImageView = image1;
        __WEAK_SELF_YLSLIDE
        [image1 sd_setImageWithURL:[NSURL URLWithString:imageViewArr[i]] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]  options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
            if(error)
                [ HUD hide:YES];
        }];
        [imageArr addObject:image1];
        image1.userInteractionEnabled = YES;
        image1.tag = 1000+i;
        UITapGestureRecognizer * imageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClick:)];
        [image1 addGestureRecognizer:imageTap];
        [self addSubview:image1];
        scrollView_height+=kScreenWidth*0.44 +10;
        
    }
    
    imageHeight+=scrollView_height;
    
    UserInfoModel * userInfo = [UserInfoModel mj_objectWithKeyValues:communityDeatilModel.user];
    
    //title
    UILabel * titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(KLeft, scrollView_height, kScreenWidth-KLeft*2, 50)];
    titleLabel.text=communityDeatilModel.title;
    titleLabel.font =DefaultBoldFontSize(18);
    titleLabel.textColor = FontColor_black;
    titleLabel.numberOfLines=0;
    CGSize size1 = [titleLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*2, MAXFLOAT)];
    titleLabel.frame  =CGRectMake(KLeft, scrollView_height, kScreenWidth-KLeft*2, size1.height);
    [self addSubview:titleLabel];
    
    scrollView_height += size1.height+10;
    
    UIImageView*_portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KLeft, scrollView_height,35,35)];
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
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
    [self addSubview:_portraitImageView];
    _portraitImageView.sd_layout
    .leftSpaceToView(self,KLeft)
    .topSpaceToView(titleLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    UILabel * nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(KLeft+45, scrollView_height, 200, 20)];
    nameLabel.font =DefaultFontSize(15);
    nameLabel.text=userInfo.name;
    nameLabel.textColor =RGBACOLOR(102, 102, 102, 1);
    CGSize size2 = [nameLabel sizeThatFits:CGSizeMake(nameLabel.frame.size.width, MAXFLOAT)];
    nameLabel.frame  =CGRectMake(KLeft+45, scrollView_height, size2.width, 35);
    [self addSubview:nameLabel];
    nameLabel.sd_layout
    .leftSpaceToView(_portraitImageView,10)
    .topEqualToView(_portraitImageView)
    .widthIs(200)
    .heightIs(20);
    
    UILabel * timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(KLeft, scrollView_height, 200, 20)];
    timeLabel.font =DefaultFontSize(13);
    timeLabel.text=communityDeatilModel.add_time;
    timeLabel.textColor =FontColor_lightGary;
    CGSize size3 = [timeLabel sizeThatFits:CGSizeMake(timeLabel.frame.size.width, MAXFLOAT)];
    timeLabel.frame  =CGRectMake(kScreenWidth-KLeft-size3.width, scrollView_height, size3.width, 35);
    [self addSubview:timeLabel];
    timeLabel.sd_layout
    .rightSpaceToView(self,KLeft)
    .topEqualToView(nameLabel)
    .heightIs(20);
    
    scrollView_height+= 45;
    
    
    
    
    UIWebView * webView =[[UIWebView alloc] init];
    NSString *url = [communityDeatilModel.content stringByAppendingString:[NSString stringWithFormat:@"&id=%@",communityDeatilModel.id]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webView.scrollView.scrollEnabled = NO;
    webView.delegate=self;
    [self addSubview:webView];
    webView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .widthIs(2987)
    .topSpaceToView(timeLabel,20);
    
    
    
    scrollView_height+=webView.frame.size.height+20;
    
    loveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [loveBtn setFrame:CGRectMake(kScreenWidth/2-80, scrollView_height, 70, 70)];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"community_detail_love"] forState:UIControlStateNormal];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"community_detail_love_selected"] forState:UIControlStateHighlighted];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"community_detail_love_selected"] forState:UIControlStateSelected];
    [loveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:loveBtn];
    loveBtn.sd_layout
    .leftSpaceToView(self,kScreenWidth/2-80)
    .topSpaceToView(webView,20)
    .widthIs(70)
    .heightIs(70);
    
    if([communityDeatilModel.is_like isEqualToString:@"1"])
    {
        loveBtn.selected = YES;
    }
    
    loveCount =[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 50, 20)];
    loveCount.text=communityDeatilModel.like_count;
    loveCount.textAlignment=NSTextAlignmentCenter;
    loveCount.font=DefaultFontSize(14);
    loveCount.textColor=FontColor_gary;
    [loveBtn addSubview:loveCount];
    
    
    //分享
    
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(kScreenWidth/2+10, scrollView_height, 70, 70)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"community_detail_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:shareBtn];
    shareBtn.sd_layout
    .leftSpaceToView(self,kScreenWidth/2+10)
    .topEqualToView(loveBtn)
    .widthIs(70)
    .heightIs(70);
    
    UILabel*shareLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 50, 20)];
    shareLabel.text=@"分享";
    shareLabel.textAlignment=NSTextAlignmentCenter;
    shareLabel.font=DefaultFontSize(14);
    shareLabel.textColor=FontColor_gary;
    [shareBtn addSubview:shareLabel];
    
    scrollView_height += 90;
    
    UILabel * line =[[UILabel alloc] initWithFrame:CGRectMake(0, scrollView_height, kScreenWidth, SINGLE_LINE_WIDTH)];
    [line setBackgroundColor:ShiXianColor];
    [self addSubview:line];
    line.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(shareBtn,20)
    .widthIs(kScreenWidth)
    .heightIs(SINGLE_LINE_WIDTH);
    
    
    
    scrollView_height +=5;
    
    
    UILabel * label1=[[UILabel alloc] initWithFrame:CGRectMake(KLeft, scrollView_height, 50, 30)];
    label1.text=@"发布于:";
    label1.textAlignment=NSTextAlignmentLeft;
    label1.textColor=FontColor_lightGary;
    label1.font=DefaultFontSize(14);
    [self addSubview:label1];
    label1.sd_layout
    .leftEqualToView(_portraitImageView)
    .topSpaceToView(line,5)
    .widthIs(50)
    .heightIs(30);
    
    
    UIButton * button1 =[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(KLeft+label1.frame.size.width, scrollView_height, 70, 30);
    [button1 setTitle:communityDeatilModel.cat_name forState:UIControlStateNormal];
    [button1 setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
    button1.titleLabel.font = DefaultFontSize(14);
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button1];
    button1.sd_layout
    .leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .widthIs(70)
    .heightIs(30);
    
    
    UIButton * button2 =[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kScreenWidth-KLeft-30, scrollView_height, 30, 30);
    [button2 setTitle:@"举报" forState:UIControlStateNormal];
    [button2 setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
    button2.titleLabel.font = DefaultFontSize(14);
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button2];
    button2.sd_layout
    .rightSpaceToView(self,KLeft)
    .topEqualToView(button1)
    .widthIs(30)
    .heightIs(30);
    
    scrollView_height +=40;
    
    UIView * backView =[[UIView alloc] initWithFrame:CGRectMake(0, scrollView_height, kScreenWidth, 10)];
    [backView setBackgroundColor:BackgroundColor];
    [self addSubview:backView];
    backView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(button1,10)
    .widthIs(kScreenWidth)
    .heightIs(10);
    
    scrollView_height+=20;
    
    UILabel * pingjia =[[UILabel alloc] initWithFrame:CGRectMake(KLeft, scrollView_height, kScreenWidth, 20)];
    pingjia.text=@"评价(56789)";
    pingjia.font= DefaultFontSize(16);
    pingjia.textColor=FontColor_lightGary;
    pingjia.textAlignment= NSTextAlignmentLeft;
    [self addSubview:pingjia];
    pingjia.sd_layout
    .leftEqualToView(_portraitImageView)
    .topSpaceToView(backView,10)
    .widthIs(kScreenWidth)
    .heightIs(20);
    
    scrollView_height +=20;
    
    curves =[[Curves alloc] initWithFrame:CGRectMake(0, scrollView_height, kScreenWidth, 10)];
    [curves setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:curves];
    curves.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(pingjia,0)
    .widthIs(kScreenWidth)
    .heightIs(10);
    scrollView_height+=10;
    
}

-(void)button1Click:(UIButton*)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToListVC" object:nil];
}

-(void)button2Click:(UIButton*)button
{
    //举报
}
-(void)loveBtnClick:(UIButton*)button
{
    if(!button.selected)
    {
        button.selected =YES;
        int xxx = [loveCount.text intValue];
        xxx+=1;
        loveCount.text =[NSString stringWithFormat:@"%d",xxx];
    }
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
-(void)shareBtnClick:(UIButton*)shareBtn
{
    [[ShareManager sharedInstance]createShareContentWithShareDict:self.communityDeatilModel.share andShareView:self];
}

-(void)imageTapClick:(UITapGestureRecognizer*)imageTap
{
    _CommunityDetailTopViewBlock(imageArr);
}




-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"=============%f",webView.scrollView.contentSize.height);
    webView.frame = CGRectMake(0, webView.top, webView.width, webView.scrollView.contentSize.height);
    [self setupAutoHeightWithBottomView:curves bottomMargin:0];
}


@end

//
//  MaskDetailFirstTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/3.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "MaskDetailFirstTableViewCell.h"


#import "FKPScrollerView.h"

@implementation MaskDetailFirstTableViewCell

-(void)setGoodModel:(GoodModel *)goodModel
{
    _goodModel = goodModel;
    [self initView];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}
-(NSMutableArray *)imageArr
{
    if(!_imageArr)
    {
        _imageArr = [NSMutableArray array];
        for (NSDictionary * dict  in self.goodModel.pictures) {
            [_imageArr addObject:[dict objectForKey:@"cover"]];
        }
    }
    
    if (_imageArr.count<=1) {
        [_imageArr addObjectsFromArray:_imageArr];
    }
    return _imageArr;
}
-(void)initView
{
   
    
    FKPScrollerView  *picView = [FKPScrollerView picScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) WithImageUrls:self.imageArr];
  
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 3.0f;
    //    picView.textColor = [UIColor redColor];
    
    [self.contentView addSubview:picView];
    
    [self.contentView addSubview:self.countView];
    _countView.sd_layout
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,KLeft)
    .widthIs(100)
    .heightIs(50);
    
    
    [self.contentView addSubview:self.nameLabel];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.goodModel.goods_name];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.goodModel.goods_name length])];
    [_nameLabel setAttributedText:attributedString1];
    CGSize size = [_nameLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*4, MAXFLOAT)];
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .rightSpaceToView(self.contentView,KLeft*3)
    .topSpaceToView(picView,KLeft)
    .heightIs(size.height);
    
    [self.contentView addSubview:self.moreButton];
    _moreButton.sd_layout
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(_nameLabel,0)
    .topSpaceToView(picView,KLeft/2)
    .heightIs(30);
    
    
    [self.contentView addSubview:self.priceLabel];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.goodModel.shop_price];
    [str addAttribute:NSFontAttributeName value:DefaultBoldFontSize(17) range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:DefaultBoldFontSize(25) range:NSMakeRange(1, self.goodModel.shop_price.length-1)];
    _priceLabel.attributedText = str;
    CGSize _priceLabelsize = [_priceLabel sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    
    [self.contentView addSubview:self.masketLabel];
    [_masketLabel setText:self.goodModel.market_price];
    CGSize _masketLabelsize = [_masketLabel sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    
    if (self.goodModel.goods_brief.length>0) {
        
        [self.contentView addSubview:self.contentLabel];
        _contentLabel.text =self.goodModel.goods_brief;
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.goodModel.goods_brief];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:7];
        
        
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self.goodModel.goods_brief length])];
        [_contentLabel setAttributedText:attributedString2];
        CGSize size1 = [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*4, MAXFLOAT)];
        _contentLabel.sd_layout
        .leftEqualToView(_nameLabel)
        .rightEqualToView(_nameLabel)
        .topSpaceToView(_nameLabel,KLeft)
        .heightIs(size1.height);

        
        
        _priceLabel.sd_layout
        .leftEqualToView(_nameLabel)
        .topSpaceToView(_contentLabel,KLeft)
        .widthIs(_priceLabelsize.width)
        .heightIs(_priceLabelsize.height);
        
        _masketLabel.sd_layout
        .leftSpaceToView(_priceLabel,KLeft)
        .topSpaceToView(_contentLabel,KLeft*2)
        .widthIs(_masketLabelsize.width)
        .heightIs(_masketLabelsize.height);
    }
    else
    {
        _priceLabel.sd_layout
        .leftEqualToView(_nameLabel)
        .topSpaceToView(_nameLabel,KLeft)
        .widthIs(_priceLabelsize.width)
        .heightIs(_priceLabelsize.height);
        
        _masketLabel.sd_layout
        .leftSpaceToView(_priceLabel,KLeft)
        .topSpaceToView(_nameLabel,KLeft*2)
        .widthIs(_masketLabelsize.width)
        .heightIs(_masketLabelsize.height);
    }
    
    
    [self.contentView addSubview:self.activityView];
    _activityView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(44)
    .topSpaceToView(_priceLabel,KLeft);
    
    [self setupAutoHeightWithBottomView:_activityView bottomMargin:0];
}

-(UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton  =[UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame =CGRectMake(kScreenWidth-30, height-5, 30, 30);
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(toImageDetail) forControlEvents:UIControlEventTouchDown];
    }
    return _moreButton;
}
-(UIView *)countView
{
    if (!_countView) {
        _countView =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-101, 10, 101, 43)];
        
        UIImageView * imageLove  =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 20)];
        [imageLove setImage:[UIImage imageNamed:@"mask_count_yellowbackground"]];
        [_countView addSubview:imageLove];
        
        UILabel * loveLabel =[[UILabel alloc] initWithFrame:CGRectMake(21, 0, 70, 20)];
        [loveLabel setTextColor:[UIColor whiteColor]];
        [loveLabel setFont:DefaultFontSize(12)];
        [loveLabel setText:[NSString stringWithFormat:@"%@人喜欢",self.goodModel.like_count]];
        [loveLabel  setTextAlignment:NSTextAlignmentRight];
        [imageLove addSubview:loveLabel];
        
        UIImageView * countImage =[[UIImageView alloc] initWithFrame:CGRectMake(6, 23, 95, 20)];
        [countImage setImage:[UIImage imageNamed:@"mask_count_redbackground"]];
        [_countView addSubview:countImage];
        
        UILabel * buyLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 20)];
        [buyLabel setTextColor:[UIColor whiteColor]];
        [buyLabel setFont:DefaultFontSize(12)];
        [buyLabel setText:[NSString stringWithFormat:@"%@人购买",self.goodModel.bought_count]];
        [buyLabel  setTextAlignment:NSTextAlignmentRight];
        [countImage addSubview:buyLabel];
    
    }
    return _countView;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel setTextColor:FontColor_black];
        [_nameLabel setFont:DefaultBoldFontSize(16)];
        [_nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _nameLabel.numberOfLines =0;
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toImageDetail)];
        [_nameLabel addGestureRecognizer:tap];
    }
    return _nameLabel;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        [_contentLabel setTextColor:FontColor_gary];
        [_contentLabel setFont:DefaultFontSize(15)];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _contentLabel.numberOfLines =0;
        
    }
    return _contentLabel;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel =[UILabel new];
        [_priceLabel setTextColor:FontColor_red];
        [_priceLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}
-(LineLabel *)masketLabel
{
    if (!_masketLabel) {
        
        _masketLabel=[[LineLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [_masketLabel setTextColor:[UIColor colorWithRed:153.00/255.00 green:153.00/255.00  blue:153.00/255.00  alpha:1]];
        [_masketLabel setFont:DefaultFontSize(16)];
        _masketLabel.strikeThroughEnabled = YES;
        _masketLabel.strikeThroughColor =[UIColor colorWithRed:153.00/255.00 green:153.00/255.00  blue:153.00/255.00  alpha:1];
    }
    return _masketLabel;
}
-(UIView *)activityView
{
    if (!_activityView) {
        
       _activityView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_activityView setBackgroundColor:[UIColor colorWithRed:251.00/255.00 green:235.00/255.00 blue:227.00/255.00 alpha:1]];
        
        UIImageView * ipheone  =[[UIImageView alloc] initWithFrame:CGRectMake(KLeft, _activityView.frame.size.height/2-10, 13, 19)];
        ipheone.image =[UIImage imageNamed:@"login_phone"];
        [_activityView addSubview:ipheone];
        
        UILabel * label1 =[[UILabel alloc] initWithFrame:CGRectMake(30, _activityView.frame.size.height/2-12, 70, 25)];
        [label1 setText:@"掌上秒杀"];
        [label1 setTextColor:[UIColor colorWithRed:252.00/255.00 green:19.00/255.00 blue:89.00/255.00 alpha:1]];
        [label1 setFont:DefaultFontSize(13)];
        [label1 setTextAlignment:NSTextAlignmentLeft];
        [_activityView addSubview:label1];
        
        UILabel * label2 =[[UILabel alloc] initWithFrame:CGRectMake(100, _activityView.frame.size.height/2-12, 70, 25)];
        [label2 setText:@"已省12元"];
        [label2 setFont:DefaultFontSize(13)];
        [label2 setTextColor: [UIColor colorWithRed:252.00/255.00 green:19.00/255.00 blue:89.00/255.00 alpha:1]];
        [label2 setTextAlignment:NSTextAlignmentLeft];
        [_activityView addSubview:label2];
        
        timerLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, _activityView.frame.size.height/2-12, kScreenWidth/2, 25)];
        [timerLabel setText:@"活动已结束"];
        [timerLabel setTextColor: [UIColor colorWithRed:252.00/255.00 green:19.00/255.00 blue:89.00/255.00 alpha:1]];
        [timerLabel setTextAlignment:NSTextAlignmentLeft];
        [timerLabel setFont:DefaultFontSize(12)];
        [_activityView addSubview:timerLabel];
        
        todate =@"2016-12-18 18:43:30";
        _timer  =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerChange:) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return _activityView;
}

-(void)subTapToWebView:(UITapGestureRecognizer *)subtap
{
    //副标题 到网页
}
-(void)toImageDetail
{
    [self.delegate toImageDetail];
}

-(void)timerChange:(NSTimer*)timer
{

    BOOL timeStart = YES;
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:todate];
    NSString *overdate = [dateFormatter stringFromDate:dateString];
    //    NSLog(@"overdate=%@",overdate);
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[overdate substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[overdate substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[overdate substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[overdate substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[overdate substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[overdate substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
    }
    
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    NSDate *overTime = [cal dateFromComponents:endTime]; //把目标时间装载入date
    //用来得到具体的时差，是为了统一成北京时间

    unsigned int unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    NSString *t = [NSString stringWithFormat:@"%ld", (long)[d day]];
    NSString *h = [NSString stringWithFormat:@"%ld", (long)[d hour]];
    NSString *fen = [NSString stringWithFormat:@"%ld", (long)[d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"0%ld",(long)[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%ld", (long)[d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%ld",(long)[d second]];
    }
    if([d day]<=0 && [d hour] <=0 && [d minute]<=0 && [d second]<=0) {
        //计时结束，
        [timerLabel setText:[NSString stringWithFormat:@"活动已结束"]];
        [_timer invalidate];
      
    } else {
        //计时未结束 do_something
         [timerLabel setText:[NSString stringWithFormat:@"剩余时间:%@天%@时%@分%@秒",t,h,fen,miao]];
        
    }
}
-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

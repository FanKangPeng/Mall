//
//  RedPacketCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "RedPacketCell.h"


@implementation RedPacketCell
@synthesize packetView,imageName;



-(void)setRedPacketModel:(RedPacketModel *)redPacketModel
{
    _redPacketModel = redPacketModel;
    UIColor * mainColor;
    if ([redPacketModel.type isEqualToString:@"100"]) {
        imageName = @"redPacket_paper_unusered.jpg";
        mainColor =NavigationBackgroundColor;
    }
    else
    {
        imageName = @"redPacket_paper_usered.jpg";
        mainColor =FontColor_lightGary;

    }
    _backImage.image = [UIImage imageNamed:imageName];
    
    _priceLabel.text =  redPacketModel.amount;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(15) range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:DefaultFontSize(30) range:NSMakeRange(1, _priceLabel.text.length-1)];
    _priceLabel.attributedText = str;
    _priceLabel.textColor = mainColor;
    CGSize sieze =[_priceLabel sizeThatFits:CGSizeMake(kScreenWidth, 40)];
    _priceLabel.sd_layout
    .widthIs(sieze.width);
    
    
    _titleLabel.textColor= mainColor;
    _titleLabel.text = redPacketModel.sn;
    
    _contentLabel.textColor = mainColor;
    _contentLabel.text = redPacketModel.name;
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth-_priceLabel.right-KLeft*5,MAXFLOAT)];
    _contentLabel.sd_layout
    .heightIs(size.height);
    
    
    _overtimeLabel.text = [NSString stringWithFormat:@"有效期:%@",redPacketModel.end_time];
    _overtimeLabel.textColor = mainColor;
    
    _timeLabel.textColor =  mainColor;
    
    if ([redPacketModel.type isEqualToString:@"100"]) {
        
        //计算倒计时
        
        NSString * eee = [self calcDaysend:redPacketModel.end_time];
        if ([eee isEqualToString:@""]) {
             _timeLabel.text= @"已过期";
            _timeLabel.textColor =FontColor_lightGary;
        }
        else
            _timeLabel.text= [NSString stringWithFormat:@"还有%@到期",eee];
        
    }
    
      if ([redPacketModel.type isEqualToString:@"101"]) {
           _timeLabel.text= @"已使用";
      }
    
    if ([redPacketModel.type isEqualToString:@"102"]) {
        _timeLabel.text= @"已过期";
    }
   
    
    
}

-(NSString*)calcDaysend:(NSString *)inEnd
{
    
    BOOL timeStart = YES;
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dateString = [dateFormatter dateFromString:inEnd];
//    NSString *overdate = [dateFormatter stringFromDate:dateString];
//    NSLog(@"overdate=%@",overdate);
    static int year;
    static int month;
    static int day;

    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[inEnd substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[inEnd substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[inEnd substringWithRange:NSMakeRange(8, 2)] intValue];
        timeStart= NO;
    }
    
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    NSDate *overTime = [cal dateFromComponents:endTime]; //把目标时间装载入date
    //用来得到具体的时差，是为了统一成北京时间
    
    unsigned int unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    NSString * timestr=@"";
  
    NSInteger timeDay = [d day];  NSInteger timeMonth=[d month];  NSInteger timeYear=[d year];
    if (timeYear>0) {
        timestr=   [timestr stringByAppendingFormat:@"%ld年",(long)[d year]];
    }
    if (timeMonth>0) {
         timestr=   [timestr stringByAppendingFormat:@"%ld月",(long)[d month]];
    }
    if (timeDay>0) {
       timestr=     [timestr stringByAppendingFormat:@"%ld天",(long)[d day]];
    }
    return timestr;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setBackgroundColor:BackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize imageSize =[UIImage imageNamed:@"redPacket_paper_usered.jpg"].size;
    packetView =[[UIView alloc] initWithFrame:CGRectMake(KLeft, KLeft, kScreenWidth-KLeft-KLeft,(kScreenWidth-KLeft-KLeft)*imageSize.height/imageSize.width)];
    [self.contentView addSubview:packetView];
    [packetView addSubview:self.backImage];
    _backImage.sd_layout
    .leftSpaceToView(packetView,0)
    .topSpaceToView(packetView,0)
    .rightSpaceToView(packetView,0)
    .bottomSpaceToView(packetView,0);
    
    [self setupAutoHeightWithBottomView:packetView bottomMargin:0];
    
    
    
    
   
    
    
    
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, packetView.height-40, packetView.width, 1)];
    [imageView setImage:[UIImage imageNamed:@"address_xuxian"]];
    [packetView addSubview:imageView];
    imageView.sd_layout
    .leftSpaceToView(packetView,0)
    .topSpaceToView(packetView,packetView.height-40)
    .rightSpaceToView(packetView,0)
    .heightIs(1);
    
    [packetView addSubview:self.priceLabel];
    [_priceLabel sizeToFit];
    _priceLabel.sd_layout
    .leftSpaceToView(packetView,KLeft)
    .topSpaceToView(packetView,imageView.top/2-10)
    .widthIs(packetView.width/4);
    
    
    UIImageView * timeImage =[[UIImageView alloc] initWithFrame:CGRectMake(20, packetView.height-25, 15, 15)];
    timeImage.image =[UIImage imageNamed:@"redPacket_time"];
    [packetView addSubview:timeImage];
    timeImage.sd_layout
    .leftSpaceToView(packetView,KLeft*2)
    .topSpaceToView(imageView,12.5)
    .widthIs(15)
    .heightIs(15);
    
    
    [packetView addSubview:self.timeLabel];
    _timeLabel.sd_layout
    .leftSpaceToView(timeImage,5)
    .topEqualToView(timeImage)
    .widthIs(100)
    .heightIs(15);
    
    
    [packetView addSubview:self.overtimeLabel];
    _overtimeLabel.sd_layout
    .rightSpaceToView(packetView,KLeft*2)
    .topEqualToView(timeImage)
    .heightIs(15)
    .widthIs(200);
    
    [packetView addSubview:self.titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView(_priceLabel,KLeft)
    .topSpaceToView(packetView,imageView.top/2-15)
    .rightSpaceToView(packetView,KLeft)
    .heightIs(20);
    
    [packetView addSubview:self.contentLabel];
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(packetView,KLeft*5)
    .topSpaceToView(_titleLabel,0);
    
    [packetView addSubview:self.selectImg];
    _selectImg.sd_layout
    .rightSpaceToView(packetView,20)
    .topSpaceToView(packetView,imageView.top/2-10)
    .widthIs(kWidth(34))
    .heightIs(kWidth(25));
  
    return self;
}
- (UIImageView *)selectImg
{
    if (!_selectImg) {
        _selectImg = [UIImageView new];
        _selectImg.image = [UIImage imageNamed:@"address_select_icon"];
        [_selectImg setHidden:true];
    }
    return _selectImg;
}
-(UIImageView *)backImage
{
    if (!_backImage) {
         _backImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    }
    return _backImage;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] init];
      
        _priceLabel.textAlignment= NSTextAlignmentCenter;
    }
    return _priceLabel;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] init];
        [_titleLabel setTextColor:FontColor_black];
        [_titleLabel setFont:DefaultFontSize(15)];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
  
    }
    return _titleLabel;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel =[[UILabel alloc] init];
        _contentLabel.textColor = FontColor_gary;
        _contentLabel.font = DefaultFontSize(13);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines=0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_contentLabel sizeToFit];

    }
    return _contentLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
       _timeLabel =[[UILabel alloc] init];
        _timeLabel.font = DefaultFontSize(12);
        _timeLabel.textColor =FontColor_lightGary;
 
    }
    return _timeLabel;
}
-(UILabel *)overtimeLabel
{
    if (!_overtimeLabel) {
        _overtimeLabel =[[UILabel alloc] init];
        _overtimeLabel.font = DefaultFontSize(12);
        _overtimeLabel.textColor =FontColor_lightGary;
        _overtimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _overtimeLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NotificationCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.icomImage];
        _icomImage.sd_layout
        .leftSpaceToView(self.contentView,KLeft)
        .topSpaceToView(self.contentView,KLeft*1.5)
        .heightIs(65)
        .widthIs(65);
        
        [self.contentView addSubview:self.titleLabel];
        _titleLabel.sd_layout
        .leftSpaceToView(_icomImage,KLeft)
        .topEqualToView(_icomImage)
        .widthIs(_titleLabel.width)
        .heightIs(20);
        
        [self.contentView addSubview:self.timeLabel];
        _timeLabel.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel,KLeft)
        .heightIs(20)
        .widthIs(_timeLabel.width);
        
        [self.contentView addSubview:self.contentLabel];
        _contentLabel.sd_layout
        .leftEqualToView(_titleLabel)
        .rightSpaceToView(self.contentView,KLeft)
        .topSpaceToView(_timeLabel,KLeft);
        
      
    }
    return self;
}

-(void)setModel:(NotificationModel *)model
{
    [_icomImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
    [_titleLabel setText:model.title];
       [_titleLabel sizeToFit];
    
    _titleLabel.sd_layout
    .widthIs(_titleLabel.width);
    [_timeLabel setText:model.add_time];
        [_timeLabel sizeToFit];
    _timeLabel.sd_layout
    .widthIs(_timeLabel.width);
    [_contentLabel setText:model.content];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.content length])];
    [_contentLabel setAttributedText:attributedString1];
    _contentLabel.numberOfLines=0;
    _contentLabel.lineBreakMode= NSLineBreakByCharWrapping;
    [_contentLabel sizeToFit];
    CGSize size1 = [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth-KLeft*3-65, MAXFLOAT)];
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_timeLabel,KLeft)
    .widthIs(size1.width)
    .heightIs(size1.height);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:KLeft];
}
-(UIImageView *)icomImage
{
    
    if (!_icomImage) {
        _icomImage = [UIImageView new];
        
    }
    return _icomImage;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel =[UILabel new];
        _titleLabel.font = DefaultFontSize(13);
        _titleLabel.textColor = FontColor_black;
     
    }
    return _titleLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel =[UILabel new];
        _timeLabel.font = DefaultFontSize(12);
        _timeLabel.textColor = FontColor_lightGary;
    
    }
    return _timeLabel;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel =[UILabel new];
        _contentLabel.font = DefaultFontSize(13);
        _contentLabel.textColor = FontColor_lightGary;
      
      
      
    }
    return _contentLabel;
}
@end

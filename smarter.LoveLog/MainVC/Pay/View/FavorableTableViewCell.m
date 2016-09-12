//
//  FavorableTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FavorableTableViewCell.h"

@implementation FavorableTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.titleLabel];
        _titleLabel.sd_layout
        .leftSpaceToView(self.contentView,KLeft)
        .topSpaceToView(self.contentView,KLeft)
        .widthIs(60)
        .heightIs(24);
        
        [self.contentView addSubview:self.TypeLabel];
        _TypeLabel.sd_layout
        .leftSpaceToView(_titleLabel,0)
        .topSpaceToView(self.contentView,15)
        .widthIs(36)
        .heightIs(17);
        
        UIImageView * image =[[UIImageView alloc] init];
        image.image=[UIImage imageNamed:@"icon_right_more.png"];
        [self.contentView addSubview:image];
        image.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,13)
        .heightIs(17)
        .widthIs(10);
        
        
        
        [self.contentView addSubview:self.distributionLabel];
        _distributionLabel.sd_layout
        .rightSpaceToView(image,5)
        .topEqualToView(image)
        .heightIs(17);
    }
    return self;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel =[UILabel new];
        _titleLabel.font = DefaultFontSize(15);
        _titleLabel.textColor = FontColor_black;
        _titleLabel.text=@"优惠卷";
        
    }
    return _titleLabel;
}
-(UILabel *)distributionLabel
{
    if(!_distributionLabel)
    {
        _distributionLabel =[UILabel new];
        _distributionLabel.font = DefaultFontSize(13);
        _distributionLabel.textColor = FontColor_black;
        _distributionLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return _distributionLabel;
}
-(UILabel *)TypeLabel
{
    if(!_TypeLabel)
    {
        _TypeLabel =[UILabel new];
        _TypeLabel.font = DefaultFontSize(11);
        _TypeLabel.textColor = [UIColor whiteColor];
        _TypeLabel.textAlignment = NSTextAlignmentCenter;
        _TypeLabel.text=@"无可用";
        _TypeLabel.backgroundColor=NavigationBackgroundColor;
        _TypeLabel.layer.cornerRadius=3;
        _TypeLabel.layer.masksToBounds=YES;
    }
    return _TypeLabel;
}
@end

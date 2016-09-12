//
//  InvoiceTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "InvoiceTableViewCell.h"

@implementation InvoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = @"发票信息";
        self.textLabel.font = DefaultFontSize(15);
        [self.contentView addSubview:self.distributionLb];
        _distributionLb.sd_layout
        .rightSpaceToView(self.contentView,KLeft)
        .leftSpaceToView(self.contentView,80)
        .topSpaceToView(self.contentView,12)
        .heightIs(20);
       
    }
    return self;
}
- (UILabel *)distributionLb
{
    if (!_distributionLb) {
        _distributionLb = [UILabel new];
        _distributionLb.textAlignment = NSTextAlignmentRight;
        _distributionLb .font = DefaultFontSize(13);
        _distributionLb.textColor = FontColor_gary;
    }
    return _distributionLb;
}
- (void)setIsShowMoreImg:(BOOL)isShowMoreImg
{
    if (isShowMoreImg) {
        
        UIImageView *  nameImage =[UIImageView new];
        nameImage.image =[UIImage imageNamed:@"icon_right_more.png"];
        [self.contentView addSubview:nameImage];
        nameImage.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,13)
        .heightIs(17)
        .widthIs(10);
        
        self.distributionLb.sd_layout
        .rightSpaceToView(self.contentView,30)
        .leftSpaceToView(self.contentView,80)
        .topSpaceToView(self.contentView,12)
        .heightIs(20);
    }
}
@end

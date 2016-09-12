//
//  MaskDetailFourTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/4.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "MaskDetailFourTableViewCell.h"

@implementation MaskDetailFourTableViewCell

- (void)awakeFromNib {
    // Initialization code
 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
    return self;
}
-(void)setGoodModel:(GoodModel *)goodModel
{
    _goodModel = goodModel;
    [self initEstimateListView];
}
-(void)initEstimateListView
{
    UILabel * title =[[UILabel alloc] initWithFrame:CGRectMake(10, 14, 120, 20)];
    title.text=@"买家点评";
    title.textColor=FontColor_lightGary;
    title.font =DefaultFontSize(16);
    [self.contentView addSubview:title];
    
//    UILabel * lable1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 35, 50, 20)];
//    lable1.textColor = FontColor_black;
//    lable1.font =SYSTEMFONT(13);
//    lable1.text=@"好评度";
//    
//    [self.contentView addSubview:lable1];
//    
//    UILabel *  haopin  =[[UILabel alloc] initWithFrame:CGRectMake(52, 35, 100, 20)];
//    haopin.font =BOLDSYSTEMFONT(14);
//    haopin.text=@"99%";
//    haopin.textColor =FontColor_lightGary;
//    [self.contentView addSubview:haopin];
    
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30, 9, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"icon_more"]];

    [self.contentView addSubview:imageView];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

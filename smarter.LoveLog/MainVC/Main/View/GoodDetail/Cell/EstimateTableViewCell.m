//
//  EstimateTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "EstimateTableViewCell.h"
#import "UserInfoModel.h"
@implementation EstimateTableViewCell

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
    if (self) {
          [self initEstimateView];
    }
    return self;
}
-(void)setModel:(EstimateModel *)model
{
    _model = model;
    UserInfoModel * user =[UserInfoModel mj_objectWithKeyValues:self.model.user];
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
    _nameLabel.text= user.name;
     _timeLabel.text=self.model.add_time;
    
    UIImage *imgtwo = [UIImage imageNamed:@"icon_comment_star_selected.png"];
    int rate =[model.cmt_rank intValue];
    
    UIImage * imgone = [UIImage imageNamed:@"icon_comment_star.png"];
    
    _image1.image = imgone;
    _image2.image = imgone;
    _image3.image = imgone;
    _image4.image = imgone;
    _image5.image = imgone;

    
    if(rate>=1)
        _image1.image = imgtwo;
    if(rate>=2)
        _image2.image = imgtwo;
    if(rate>=3)
        _image3.image = imgtwo;
    if(rate>=4)
        _image4.image = imgtwo;
    if(rate>=5)
        _image5.image = imgtwo;
    
    _contentLable.text=model.content;
    CGSize zied =    [_contentLable sizeThatFits:CGSizeMake(kScreenWidth-20, 200)];
    _contentLable.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.portraitImageView,KLeft)
    .widthIs(kScreenWidth-20)
    .heightIs(zied.height);
    
   
}
-(void)initEstimateView
{

    [self.contentView addSubview:self.portraitImageView];
    _portraitImageView.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,KLeft)
    .widthIs(35)
    .heightIs(35);
    
    _nameLabel =[[UILabel alloc] init];
    _nameLabel.textColor = FontColor_gary;
    _nameLabel.font=DefaultFontSize(13);
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .topEqualToView(_portraitImageView)
    .leftSpaceToView(_portraitImageView,KLeft/2)
    .heightIs(20)
    .widthIs(200);
    
    _timeLabel  =[[UILabel alloc] init];
   
    _timeLabel.textColor =FontColor_gary;
    _timeLabel.font =DefaultFontSize(10);
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout
    .topSpaceToView(_nameLabel,-KLeft/2)
    .leftEqualToView(_nameLabel)
    .heightIs(20)
    .widthIs(200);
    
    
   
    
    [self.contentView addSubview:self.image1];
    [self.contentView addSubview:self.image2];
    [self.contentView addSubview:self.image3];
    [self.contentView addSubview:self.image4];
    [self.contentView addSubview:self.image5];
    

    
    _contentLable =[[UILabel alloc] init];
    _contentLable.textColor=FontColor_black;
 
    _contentLable.textAlignment=NSTextAlignmentLeft;
    _contentLable.font=DefaultFontSize(13);
    [_contentLable setLineBreakMode:NSLineBreakByCharWrapping];
    _contentLable.numberOfLines=0;
  
    [self.contentView addSubview:_contentLable];
   [self setupAutoHeightWithBottomView:_contentLable bottomMargin:KLeft];

}
- (UIImageView *)image1
{
    if (!_image1) {
         _image1= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-88, 10, 12, 12)];
       
    }
    return _image1;
}
- (UIImageView *)image2
{
    if (!_image2) {
       _image2= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-73, 10, 12, 12)];
        
    }
    return _image2;
}
- (UIImageView *)image3
{
    if (!_image3) {
        _image3= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-58, 10, 12, 12)];
     
    }
    return _image3;
}
- (UIImageView *)image4
{
    if (!_image4) {
       _image4= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-43, 10, 12, 12)];
       
    }
    return _image4;
}
- (UIImageView *)image5
{
    if (!_image5) {
         _image5= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-27, 10, 12, 12)];
      
    }
    return _image5;
}
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5,35,35)];
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
//        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cishanBtnClick:)];
//        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

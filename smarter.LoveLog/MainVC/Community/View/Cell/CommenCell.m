//
//  CommenCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "CommenCell.h"
#import "UserInfoModel.h"
@implementation CommenCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
    return  self;
}
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KLeft*2,KLeft,40,40)];
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

-(void)initView
{
    [self.contentView addSubview:self.portraitImageView];
    _portraitImageView.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,KLeft)
    .heightIs(40)
    .widthIs(40);
    
    _nameLabel =[[UILabel alloc] init];
    _nameLabel.font =DefaultFontSize(13);
    
    _nameLabel.textColor =RGBACOLOR(102, 102, 102, 1);
    
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(_portraitImageView,KLeft)
    .topSpaceToView(self.contentView,KLeft+12.5)
    .heightIs(15)
    .widthIs(200);
    
    
    _timeLabel =[[UILabel alloc] init];
    _timeLabel.font =DefaultFontSize(12);
    
    _timeLabel.textColor =FontColor_lightGary;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout
    .rightSpaceToView(self.contentView,KLeft)
    .topEqualToView(_nameLabel)
    .heightIs(15)
    .widthIs(100);
    
    
    _concentLabel =[[UILabel alloc] init];
    _concentLabel.font =DefaultFontSize(13);
    _concentLabel.numberOfLines =0;
    
    _concentLabel.textColor =RGBACOLOR(51, 51, 51, 1);

    
    
    [self.contentView addSubview:_concentLabel];
    _concentLabel.sd_layout
    .leftEqualToView(_portraitImageView)
    .topSpaceToView(_portraitImageView,KLeft)
    .rightSpaceToView(self.contentView,KLeft);
    
    
    // [self setNeedsDisplay];
    
    
    
    [self setupAutoHeightWithBottomView:_concentLabel bottomMargin:8];
    
}

-(void)setCommentModel:(Community_CommentModel *)commentModel
{
    _commentModel = commentModel;
    UserInfoModel * userInfo  =[UserInfoModel mj_objectWithKeyValues:commentModel.user];
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
    
    _nameLabel.text=userInfo.name;
    
    
    _timeLabel.text=commentModel.add_time;
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:commentModel.content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [commentModel.content length])];
    [_concentLabel setAttributedText:attributedString1];
    [_concentLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize  size = [_concentLabel sizeThatFits:CGSizeMake(kScreenWidth- _portraitImageView.right -KLeft, MAXFLOAT)];
    _concentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .heightIs(size.height)
    .widthIs(size.width);
    
    
}


@end

//
//  MyCommentCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/22.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MyCommentCell.h"
#import "UserInfoModel.h"

@implementation MyCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initView];
    }
    return self;
}
-(void)setCommentModel:(MyCommentModel *)commentModel
{
    _commentModel  = commentModel;
    UserInfoModel * userInfo  =[UserInfoModel mj_objectWithKeyValues:commentModel.user];
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"replace_UserIcon"]];
    
    _nameLabel.text=userInfo.name;
    
    
    _timeLabel.text=commentModel.add_time;
    
    
    _concentLabel.attributedText = [commentModel.content expressionAttributedStringWithExpression:self.exp];
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithAttributedString:_concentLabel.attributedText];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_concentLabel.attributedText length])];
    [_concentLabel setAttributedText:attributedString1];
    [_concentLabel sizeToFit];
    _concentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .heightIs(_concentLabel.height+10)
    .rightSpaceToView(self.contentView,KLeft);
    
    NSString * objectText =[NSString stringWithFormat:@"%@",[commentModel.object objectForKey:@"title"]];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:objectText];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [objectText length])];
    [_objectLabel setAttributedText:attributedString];

    [_objectLabel sizeToFit];
    _objectLabel.sd_layout
    .leftEqualToView(_concentLabel)
    .topSpaceToView(_concentLabel,5)
    .rightSpaceToView(self.contentView,KLeft)
    .heightIs(_objectLabel.height+10);
    
    
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
- (MLExpression *)exp
{
    if (!_exp) {
        _exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression1" bundleName:@"expression"];
    }
    return _exp;
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
    .widthIs(150);
    
    
    _concentLabel =[[MLLabel alloc] init];
    _concentLabel.font =DefaultFontSize(13);
    _concentLabel.numberOfLines =0;
    _concentLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    _concentLabel.textColor =RGBACOLOR(51, 51, 51, 1);
    _concentLabel.textAlignment = NSTextAlignmentNatural;
    
    
    [self.contentView addSubview:_concentLabel];
    _concentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,KLeft)
    .rightSpaceToView(self.contentView,KLeft);
    
    
    _objectLabel = [UILabel new];
    [_objectLabel setBackgroundColor:BackgroundColor];
    _objectLabel.font = DefaultFontSize(13);
    _objectLabel.numberOfLines = 0;
     _objectLabel.textAlignment = NSTextAlignmentNatural;
    _objectLabel.textColor =RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:_objectLabel];
    _objectLabel.sd_layout
    .leftEqualToView(_concentLabel)
    .topSpaceToView(_concentLabel,5)
    .rightSpaceToView(self.contentView,KLeft);
    
     [self setupAutoHeightWithBottomView:_objectLabel bottomMargin:8];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_objectLabel addGestureRecognizer:tap];
    
}
-(void)tap:(UIGestureRecognizer*)tap
{
    _MyCommentCellBlock(self.commentModel);
}


@end

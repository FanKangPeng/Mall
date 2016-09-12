//
//  CommunityCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityCell.h"
#import "Curves.h"
#import "UserInfoModel.h"
#import "CommunityTool.h"
@implementation CommunityCell
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
-(UIButton *)likeButton
{
    if(!_likeButton)
    {
        _likeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setFrame:CGRectMake(0, 0, 52, 20)];
        
        [_likeButton setImage:[UIImage imageNamed:@"icon_zan_list"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"IMG_PostDetail_zan"] forState:UIControlStateSelected];
        [_likeButton setTitleColor:FontColor_lightGary forState:UIControlStateNormal];
        _likeButton.titleLabel.font = DefaultFontSize(13);
        _likeButton.titleLabel.textAlignment =  NSTextAlignmentRight;
        [_likeButton addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchDown];
    }
    return _likeButton;
}
-(void)updataButton:(id)obj
{
    _likeButton.selected =  YES;
    [_likeButton setTitle:[obj objectForKey:@"total"] forState:UIControlStateNormal];
}
-(void)dianzan
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    
    [CommunityTool commentTop:@"comment/digg" params:@{@"id":_commentModel.cmt_id} success:^(id obj) {
        [hud hide:YES];
        [self updataButton:obj];
        
    } failure:^(id obj) {
        [hud hide:YES];
        if([obj isKindOfClass:[NSError class]])
        {
            NSError * err = obj;
            
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        {
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
               [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
            {
                HUDSHOW([obj objectForKey:@"error_desc"]);
                
            }
            
        }
        
        
    }];

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
    .topSpaceToView(self.contentView,KLeft+3)
    .heightIs(15)
    .widthIs(200);
    
    
    _timeLabel =[[UILabel alloc] init];
    _timeLabel.font =DefaultFontSize(12);

    _timeLabel.textColor =FontColor_lightGary;
 
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,5)
    .heightIs(15)
    .widthIs(200);
 
    
    [self.contentView addSubview:self.concentLabel];
    _concentLabel.sd_layout
    .leftSpaceToView(_portraitImageView,KLeft)
    .topSpaceToView(_portraitImageView,5)
    .rightSpaceToView(self.contentView,KLeft);
    
    
    
    [self.contentView addSubview:self.likeButton];
    _likeButton.sd_layout
    .rightSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,KLeft*2)
    .heightIs(20)
    .widthIs(60);
    
      [self setupAutoHeightWithBottomView:_concentLabel bottomMargin:8];

}
- (MLLabel *)concentLabel
{
    if (!_concentLabel) {
        _concentLabel = [MLLabel new];
        _concentLabel.textColor =  FontColor_black;
        _concentLabel.font = DefaultFontSize(13);
        _concentLabel.numberOfLines = 0;
        _concentLabel.lineBreakMode=  NSLineBreakByTruncatingTail;
    }
    return _concentLabel;
}
- (MLExpression *)exp
{
    if (!_exp) {
        _exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression1" bundleName:@"expression"];
    }
    return _exp;
}
-(void)setCommentModel:(Community_CommentModel *)commentModel
{
    _commentModel = commentModel;
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
    CGSize size = [_concentLabel sizeThatFits:CGSizeMake(kScreenWidth - KLeft*2 - self.portraitImageView.right, MAXFLOAT)];
    _concentLabel.sd_layout
    .heightIs(size.height);

    
    if ([commentModel.is_digg isEqualToString:@"1"]) {
        _likeButton.selected = YES;
    }
    
    [_likeButton setTitle:commentModel.digg_count forState:UIControlStateNormal];
    [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0,40, 0,0)];
    [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(5,0, 0,20)];

}




- (NSDictionary *)faceDict
{
    if (!_faceDict) {
        _faceDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FaceMap_Antitone" ofType:@"plist"]];
    }
    return _faceDict;
}

@end

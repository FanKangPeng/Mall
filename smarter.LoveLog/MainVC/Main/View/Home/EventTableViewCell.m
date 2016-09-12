
//
//  EventTableViewCell.m
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

-(void)setActionArr:(NSArray *)actionArr
{
    _actionArr = actionArr;
    Action * actionone =actionArr[0];
    Action * actiontwo =actionArr[1];
    Action * actionthree =actionArr[2];
    
    _action1.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:actionone.image_url];
     _action2.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:actiontwo.image_url];
     _action3.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:actionthree.image_url];
    if (_action1.image == nil) {
       [_action1 sd_setImageWithURL:[NSURL URLWithString:actionone.image_url] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
        [[SDImageCache sharedImageCache] storeImage:_action1.image forKey:actionone.image_url];
    }
    if (_action2.image == nil) {
        [_action2 sd_setImageWithURL:[NSURL URLWithString:actiontwo.image_url] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
        [[SDImageCache sharedImageCache] storeImage:_action2.image forKey:actiontwo.image_url];
    }

    if (_action3.image == nil) {
        [_action3 sd_setImageWithURL:[NSURL URLWithString:actionthree.image_url] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
        [[SDImageCache sharedImageCache] storeImage:_action3.image forKey:actionthree.image_url];
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setBackgroundColor:BackgroundColor];
    
    UIView * backgroundView =[[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth, (kScreenWidth/2-9.5)*0.955)];
    [self.contentView addSubview:backgroundView];
    
    //活动1
    [backgroundView addSubview:self.action1];
    _action1.sd_layout
    .leftSpaceToView(backgroundView,7)
    .bottomSpaceToView(backgroundView,0)
    .widthIs(kScreenWidth/2-9.5);
    
    
    
    //活动2
    [backgroundView addSubview:self.action2];
    _action2.sd_layout
    .rightSpaceToView(backgroundView,7)
    .heightIs(backgroundView.frame.size.height/2-2.5)
    .widthIs(kScreenWidth/2-9.5);
    
    
    //活动3
    [backgroundView addSubview:self.action3];
    _action3.sd_layout
    .rightSpaceToView(backgroundView,7)
    .bottomSpaceToView(backgroundView,0)
    .heightIs(backgroundView.frame.size.height/2-2.5)
    .widthIs(kScreenWidth/2-9.5);
    
    return self;
}
-(UIImageView *)action1
{
    if(!_action1)
    {
        _action1 =[[UIImageView alloc] init];
        _action1.userInteractionEnabled  = YES;
        UITapGestureRecognizer * tap1  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action1Click:)];
        [_action1 addGestureRecognizer:tap1];
       
    }
    return _action1;
}
-(UIImageView *)action2
{
    if(!_action2)
    {
        _action2 =[[UIImageView alloc] init];
        _action2.userInteractionEnabled  = YES;
        UITapGestureRecognizer * tap2  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action2Click:)];
        [_action2 addGestureRecognizer:tap2];
        
    }
    return _action2;
}
-(UIImageView *)action3
{
    if(!_action3)
    {
        _action3 =[[UIImageView alloc] init];
        _action3.userInteractionEnabled  = YES;
        UITapGestureRecognizer * tap3  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action3Click:)];
        [_action3 addGestureRecognizer:tap3];
        
    }
    return _action3;
}
/**
 活动1事件
 */
-(void)action1Click:(UITapGestureRecognizer *) tap
{
    
    Action * actionone =_actionArr[0];
 

    _ActionBlock(actionone.action,actionone.param);
}
/**
 活动2事件
 */
-(void)action2Click:(UITapGestureRecognizer *) tap
{
       Action * actiontwo =_actionArr[1];
    _ActionBlock(actiontwo.action,actiontwo.param);
}
/**
 活动3事件
 */
-(void)action3Click:(UITapGestureRecognizer *) tap
{
        Action * actionthree =_actionArr[2];
    _ActionBlock(actionthree.action,actionthree.param);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  AdvertisementTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AdvertisementTableViewCell.h"
#define ImageHeight (kScreenWidth-14)/5

@implementation AdvertisementTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:BackgroundColor];
    UIView * backgroundView1  =[[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth, ImageHeight+14)];
    [backgroundView1 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backgroundView1];
    [backgroundView1 addSubview:self.actionImage];
    _actionImage.sd_layout
    .leftSpaceToView(backgroundView1,7)
    .rightSpaceToView(backgroundView1,7)
    .topSpaceToView(backgroundView1,7)
    .bottomSpaceToView(backgroundView1,7);
    
    return self;
    
}
-(void)setActionArray:(NSArray *)actionArray
{
    _actionArray =actionArray;
    Action * action1 =actionArray[2];
    UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:action1.image_url];
    if (image) {
        _actionImage .image = image;
    }
    else
    {
        [_actionImage sd_setImageWithURL:[NSURL URLWithString:action1.image_url] placeholderImage:[UIImage imageNamed:@"image_loadding_background.jpg"]];
        [[SDImageCache sharedImageCache] storeImage:_actionImage.image forKey:action1.image_url];
    }

}
-(UIImageView *)actionImage
{
    if(!_actionImage)
    {
        _actionImage =[[UIImageView alloc] initWithFrame:self.bounds];
        _actionImage.userInteractionEnabled  = YES;
        UITapGestureRecognizer * tap1  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action1Click:)];
        [_actionImage addGestureRecognizer:tap1];
        
    }
    return _actionImage;
}
-(void)action1Click:(UITapGestureRecognizer*)tap
{
     Action * action1 =self.actionArray[2];
    _advertisementBlock(action1.action,action1.param);
}
-(void)advertisementClick:(AdvertisementBlock)advertisementBlock
{
    _advertisementBlock =advertisementBlock;
}


@end

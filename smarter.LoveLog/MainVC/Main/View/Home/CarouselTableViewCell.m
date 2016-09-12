//
//  CarouselTableViewCell.m
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//



#import "CarouselTableViewCell.h"
#import "FKPScrollerView.h"

@implementation CarouselTableViewCell


-(void)setSliderArr:(NSArray *)sliderArr
{
    NSMutableArray * imageArr =[NSMutableArray array];
    for (Slider* slider  in sliderArr) {
        [imageArr addObject:slider.image_url];
    }
    
    FKPScrollerView  *picView = [FKPScrollerView picScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2) WithImageUrls:imageArr];
   // picView.titleData = titleArray;
    
    //占位图片,你可以在下载图片失败处修改占位图片
  //  picView.placeImage = [UIImage imageNamed:@"place.png"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        Slider * slider =sliderArr[index];
        if(slider)
        {
            _CarouselCellBlock(slider.action,slider.param);
        }
    }];
    picView.style = PageControlAtRight;
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 3.0f;
    //    picView.textColor = [UIColor redColor];
    
    [self.contentView addSubview:picView];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if(self)
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

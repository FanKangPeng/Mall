//
//  OtherTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "OtherTableViewCell.h"
#define CELL_HEIGHT 100

@implementation OtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)dict
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
       self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:BackgroundColor];
    [self initViewWithDict:dict];
    return  self;
}
-(void)initViewWithDict:(NSDictionary*)dict
{
    
  
    
    
    if([dict.allKeys.firstObject isEqual:nil])
    {
       
    }
    if([dict.allKeys.firstObject isEqualToString:@"labelText"])
    {
        UIImageView * backImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CELL_HEIGHT)];
        backImage.image =[UIImage imageNamed:@"userInfo_middle_BackImage.jpg"];
        [self.contentView addSubview:backImage];
        
        
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, CELL_HEIGHT)];
        [label setText:[dict.allValues lastObject]];
        [label setTextColor:[UIColor whiteColor]];
        label.numberOfLines =0;
        label.lineBreakMode =NSLineBreakByCharWrapping;
        label.font =DefaultFontSize(15);
        [self.contentView addSubview:label];
    }
    if([dict.allKeys.firstObject isEqualToString:@"button"])
    {
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(20, 15, kScreenWidth-40, 40);
        [button setBackgroundColor:NavigationBackgroundColor];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"联系客服" forState:UIControlStateNormal];
        button.titleLabel.font =DefaultFontSize(18);
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:button];
    }
}
-(void)buttonClick:(UIButton*)button
{
    _otherCellBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

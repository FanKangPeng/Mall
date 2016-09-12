//
//  SumTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SumTableViewCell.h"

@implementation SumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)setSumArr:(NSArray *)sumArr
{
    [self.contentView removeAllSubviews];
    for (int i = 0 ; i <sumArr.count;i++) {
        NSDictionary * sumDict = sumArr[i];
        UILabel * keyLabel =[[UILabel alloc] initWithFrame:CGRectMake(KLeft, 10 + 25*i, kScreenWidth/2, 20)];
        keyLabel.text = sumDict.allKeys.lastObject;
        keyLabel.textColor =FontColor_black;
        keyLabel.font = DefaultFontSize(15);
        
        [self.contentView addSubview:keyLabel];
        
        UILabel * valueLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 10+ 25*i, kScreenWidth/2-KLeft, 20)];
        valueLabel.textAlignment = NSTextAlignmentRight;
        NSString * valueStr =[NSString stringWithFormat:@"%@",[sumDict objectForKey:sumDict.allKeys.lastObject]];
        
        [valueLabel setText:valueStr];
        valueLabel.textColor = NavigationBackgroundColor;
        valueLabel.font = DefaultFontSize(13);
        [self.contentView addSubview:valueLabel];
        
        if(i == sumArr.count-1)
        {
            [self setupAutoHeightWithBottomView:valueLabel bottomMargin:10];
        }
    }
}

@end

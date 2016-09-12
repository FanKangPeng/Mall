//
//  MaskDetailThreeTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/4.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "MaskDetailThreeTableViewCell.h"

@implementation MaskDetailThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMask:(Mask *)mask
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UITableView * table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) style:UITableViewStylePlain];
    table.delegate =self;
    table.dataSource =self;
    table.separatorStyle =UITableViewCellSeparatorStyleNone;
    table.scrollEnabled=NO;
    [self addSubview:table];
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
        return 40;
    else
        return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(indexPath.row==1)
    {
        UITableViewCell * cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSArray * arr =@[@"正品保障",@"满10包邮",@"365天保价"];
        for (int i =0; i<3; i++)
        {
            UIView * backView  =[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/3*i, 0, kScreenWidth/3, 40)];
            UILabel * label1 =[[UILabel alloc] init];
            label1.text =arr[i];
            [label1 setTextColor:[UIColor grayColor]];
            label1.font=DefaultFontSize(14);
            label1.textAlignment=NSTextAlignmentLeft;
            [backView addSubview:label1];
            UIImageView * imageView =[[UIImageView alloc] init];
            [imageView  setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mask_detail_Image_%d.png",i]]];
            [backView addSubview:imageView];
            
            switch (i) {
                case 0:
                {
                    label1.frame =CGRectMake(backView.frame.size.width-70, 10, 70, 20);
                    imageView.frame  =CGRectMake(backView.frame.size.width-95, 10, 20, 20);
                }
                    break;
                case 1:
                {
                    label1.frame =CGRectMake(backView.frame.size.width/2-25, 10, 70, 20);
                    imageView.frame  =CGRectMake(backView.frame.size.width/2-50, 10, 20, 20);
                }
                    break;
                case 2:
                {
                    label1.frame =CGRectMake(25, 10, 70, 20);
                    imageView.frame  =CGRectMake(0, 10, 20, 20);
                }
                    break;
                    
                default:
                    break;
            }
            
            [cell.contentView addSubview:backView];
        }
        return cell;
    }
    else
    {
        UITableViewCell * cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell1"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:BackgroundColor];
        return cell;
    }
    
    
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

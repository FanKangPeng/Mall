//
//  MaskDetailSecondTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/4.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "MaskDetailSecondTableViewCell.h"

@implementation MaskDetailSecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
     [self setBackgroundColor:MJRandomColor];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dict = @{@"count":@"5"};
        if (!_listView) {
            [self.contentView addSubview:self.listView];
        }
        else
        {
            [self.listView reloadData];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"ChangeSize" object:nil];

    }
   
    
    return self;
}
-(void)changeSize:(NSNotification*)notification
{
    NSDictionary * dict = notification.object;
    _dict =  dict;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}
-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [self.listView reloadData];
    
}
-(void)setGoodModel:(GoodModel *)goodModel
{
    _goodModel = goodModel;
    [self.listView reloadData];
}
-(UITableView *)listView
{
    if (!_listView) {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.scrollEnabled =NO;

    }
    return _listView;
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
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    
    label.textColor =[UIColor grayColor];
    label.font =DefaultFontSize(15);
    [cell.contentView addSubview:label];
    NSArray * arr =@[@"已选:",@"库存:",@"购物须知:"];
    label.text =arr[indexPath.row];
    
    
    UILabel * detailLabel  =[[UILabel alloc] initWithFrame:CGRectMake(70,15,200,20)];
    
    detailLabel.textAlignment=NSTextAlignmentLeft;
    detailLabel.textColor =[UIColor blackColor];
    detailLabel.font =DefaultFontSize(15);
    
    [cell.contentView addSubview:detailLabel];
    
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30, cell.frame.size.height/2-15, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"icon_more"]];
    
    
    
    
    if(indexPath.row ==0)
    {
        detailLabel.text= [NSString stringWithFormat:@"%@个",[self.dict objectForKey:@"count"]];
        [cell.contentView addSubview: imageView];
    }
    if(indexPath.row ==1)
    {
        detailLabel.text=[self.goodModel.goods_number isEqualToString:@"0"]? @"库存不足": self.goodModel.goods_number;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if(indexPath.row ==2)
    {
        detailLabel.textColor =[UIColor grayColor];
        detailLabel.text= [NSString stringWithFormat:@"客服时间8:30-23:00"];
         [cell.contentView addSubview: imageView];
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            //
            _SpecificationBlock();
            break;
        case 1:
            //
            break;
        case 2:
            //
            _NoticeBlock();
            break;
            
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

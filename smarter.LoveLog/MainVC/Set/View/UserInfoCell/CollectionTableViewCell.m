//
//  CollectionTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CollectionTableViewCell.h"

#define CELL_WIDTH kScreenWidth/4


@implementation CollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)dict
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _dict  =dict;
      [self setBackgroundColor:[UIColor whiteColor]];
       self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout * collectionflowlayout  =[[UICollectionViewFlowLayout alloc] init];
    collectionViewList  =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.76) collectionViewLayout:collectionflowlayout];
    [collectionViewList setBackgroundColor:BackgroundColor];
    collectionViewList.delegate=self;
    collectionViewList.dataSource =self;
    [self addSubview:collectionViewList];
    collectionViewList.scrollEnabled =NO;
    
    [collectionViewList registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    return  self;
}
#pragma mark ---UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView * imageView  =[[UIImageView alloc] initWithFrame:CGRectMake(CELL_WIDTH/2-kScreenWidth/20, CELL_WIDTH/5, kScreenWidth/10+1, kScreenWidth/10)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image =[[UIImage imageNamed:[NSString stringWithFormat:@"userInfo_collection_icon_%ld%ld",(long)indexPath.section,(long)indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.contentView addSubview:imageView];
    imageView.sd_layout
    .leftSpaceToView(cell.contentView,cell.width/2-kScreenWidth/20)
    .widthIs(kScreenWidth/10+2)
    .topSpaceToView(cell.contentView,cell.height/2-(kScreenWidth/10+kScreenWidth/16)/2)
    .heightIs(kScreenWidth/10);
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, CELL_WIDTH/5+kScreenWidth/8, CELL_WIDTH, CELL_WIDTH/4)];
    label.font =DefaultFontSize(14);
    label.textColor =FontColor_black;
    label.textAlignment =NSTextAlignmentCenter;
    label.text=[_dict.allValues lastObject][indexPath.section][indexPath.row];
    [cell.contentView addSubview:label];
    label.sd_layout
    .leftSpaceToView(cell.contentView,0)
    .rightSpaceToView(cell.contentView,0)
    .topSpaceToView(imageView,kScreenWidth/70)
    .heightIs(kScreenWidth/16);
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    return cell;
}

//定义每个UICollectionView 的大小（返回CGSize：宽度和高度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return   CGSizeMake(CELL_WIDTH-0.5, CELL_WIDTH);
}
//定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 0, 1, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * name=[_dict.allValues lastObject][indexPath.section][indexPath.row];
    _CollectionCellBlock(name);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

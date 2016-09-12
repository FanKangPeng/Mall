//
//  ClassifyTableViewCell.m
//  LoveLog
//
//  Created by 樊康鹏 on 15/11/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "ClassifyTableViewCell.h"
#import "Action.h"


@implementation ClassifyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    

    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.imageView1];
        _imageView1.sd_layout
        .leftSpaceToView(self.contentView,7)
        .rightSpaceToView(self.contentView,7)
        .topSpaceToView(self.contentView,7)
        .heightIs(kScreenWidth / 4);
        
        [self.contentView addSubview:self.imageView2];
        _imageView2.sd_layout
        .leftSpaceToView(self.contentView,7)
        .rightSpaceToView(self.contentView,7)
        .topSpaceToView(self.imageView1,7)
        .heightIs(kScreenWidth / 4);
        [self setupAutoHeightWithBottomView:_imageView2 bottomMargin:7];
    }
    
    return self;
   
}

-(void)setActionArray:(NSArray *)actionArray
{
    _actionArray =actionArray;
    Action * action1 =actionArray[0];
    Action * action2 =actionArray[1];
    
   UIImage * img1 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:action1.image_url];
   UIImage * img2 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:action2.image_url];
    
    if (img1 != nil) {
        [_imageView1 setImage:img1];
        _imageView1.sd_layout
        .heightIs(kScreenWidth / img1.size.width * img1.size.height);
        
    }
    else
    {
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:action1.image_url]]];
        [_imageView1 setImage:image];
        _imageView1.sd_layout
        .heightIs(kScreenWidth / image.size.width * image.size.height);
        [[SDImageCache sharedImageCache] storeImage:image forKey:action1.image_url];
    }
    
    if (img2 != nil) {
        [_imageView2 setImage:img2];
        _imageView2.sd_layout
        .heightIs(kScreenWidth / img2.size.width * img2.size.height);
    }
    else
    {
         UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:action2.image_url]]];
        [_imageView2 setImage:image];
        _imageView2.sd_layout
        .heightIs(kScreenWidth / image.size.width * image.size.height);
          [[SDImageCache sharedImageCache] storeImage:image forKey:action2.image_url];
    }
}

- (UIImageView *)imageView2
{
    if (!_imageView2) {
        _imageView2 = [UIImageView new];
        _imageView2.userInteractionEnabled =YES;
        _imageView2.image = [UIImage imageNamed:@"image_loadding_background.jpg"];
        UITapGestureRecognizer * taptwo  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action2Click:)];
        [_imageView2 addGestureRecognizer:taptwo];
    }
    return _imageView2;
}
- (UIImageView *)imageView1
{
    if (!_imageView1) {
        _imageView1 = [UIImageView new];
        _imageView1.userInteractionEnabled =YES;
         _imageView1.image = [UIImage imageNamed:@"image_loadding_background.jpg"];
        UITapGestureRecognizer * tapone  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action1Click:)];
        [_imageView1 addGestureRecognizer:tapone];
    }
    return _imageView1;
}

-(void)action1Click:(UITapGestureRecognizer *)tap
{
    Action * action =_actionArray[0];
    
    _ClassifyTableViewCellOneBlock(action.action,action.param);
}
-(void)action2Click:(UITapGestureRecognizer *)tap
{
    Action * action =_actionArray[1];
    FLog(@"%@",action.param);
    _ClassifyTableViewCellTwoBlock(action.action,action.param);
}

/*
 //此部分为另一种布局方式 布局为uicollection  两行两列的产品展示布局
-(void)createUI
{
    [self setBackgroundColor:BackgroundColor];
    topImage  =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    topImage.userInteractionEnabled =YES ;
    topImage.image  =[UIImage imageNamed:@"topImage.png"];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topImageClick:)];
    [topImage addGestureRecognizer:tap];
    [self addSubview:topImage];
  
    //间隔5个像素
    UICollectionViewFlowLayout * collectionflowlayout  =[[UICollectionViewFlowLayout alloc] init];
    collectionViewList  =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 500) collectionViewLayout:collectionflowlayout];
    [collectionViewList setBackgroundColor:BackgroundColor];
    collectionViewList.delegate=self;
    collectionViewList.dataSource =self;
    [self addSubview:collectionViewList];
    collectionViewList.scrollEnabled =NO;
  
    [collectionViewList registerClass: [IntroductionCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    
    
    
}
#pragma mark ---
#pragma UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntroductionCollectionViewCell * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   
    return cell;
}

//定义每个UICollectionView 的大小（返回CGSize：宽度和高度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return   CGSizeMake(kScreenWidth/2-8, kScreenWidth/2+47);
}
//定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   return  UIEdgeInsetsMake(10, 6, 0, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSString * maskName  =@"面膜";
    _detailsBlock(maskName);
}

*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

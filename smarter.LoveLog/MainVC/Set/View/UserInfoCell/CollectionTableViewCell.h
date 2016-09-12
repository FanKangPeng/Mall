//
//  CollectionTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/22.
//  Copyright © 2015年 FanKing. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * collectionViewList;
}
@property (nonatomic,strong)NSDictionary * dict;
@property (nonatomic,copy)void(^CollectionCellBlock)(NSString * name);

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)dict;
@end

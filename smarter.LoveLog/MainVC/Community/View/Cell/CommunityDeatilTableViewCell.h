//
//  CommunityDeatilTableViewCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/10.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityDetailModel.h"
#import "Curves.h"


@interface CommunityDeatilTableViewCell : UITableViewCell<MBProgressHUDDelegate,UIWebViewDelegate>
{
    
    NSMutableArray * imageArr;
    UILabel * loveCount;
    CGFloat imageHeight;
    UIButton * loveBtn;
    Curves * curves;
}

@property(nonatomic,strong)CommunityDetailModel * communityDeatilModel;
@property(nonatomic,copy)void(^CommunityDetailTopViewBlock)(NSArray * imageArray);

@end

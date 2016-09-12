//
//  CommunityViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/1.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "BaseViewController.h"
#import "CommunityTopView.h"

@interface CommunityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView * communityList;
@property (nonatomic ,strong)CommunityTopView * CommunityTopView;
@property(nonatomic,strong)NSMutableDictionary * communityDict;
//@property(nonatomic,assign)NSUInteger pageCount;
@property (nonatomic ,assign) id  errorDict;

@property(nonatomic,strong)NSArray * imageArr;

@end

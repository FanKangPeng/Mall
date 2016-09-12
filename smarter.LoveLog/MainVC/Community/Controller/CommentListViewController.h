//
//  CommentListViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/17.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "FaceBoard.h"
#import "FKPTextView.h"
@interface CommentListViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FKPTextViewDelegate>
/**评论数据源*/
@property (nonatomic ,strong) NSMutableDictionary * commentDict;
/**get comment error*/
@property (nonatomic ,assign) id  CommentError;
/**load more error*/
@property (nonatomic ,assign) id  LoadMoreError;
/**send commenterror*/
@property (nonatomic ,assign) id  SendCommentError;
@property (nonatomic ,strong) UITableView *estimateListView;
@property (nonatomic ,strong) NSString *post_id;
@property (nonatomic ,assign) NSUInteger pageCount;
@property (nonatomic ,copy) void(^EstimateListBlock)();

@property (nonatomic ,strong) FaceBoard *faceBoard;
@property (nonatomic ,strong) UIButton *faceButton;

@property (nonatomic ,strong) UIView *tabView;
@property (nonatomic ,strong) FKPTextView *commeunityTextView;
@property (nonatomic ,strong) UIButton *sendButton;
@property (nonatomic ,assign) BOOL isShowKeyBoard;
@property (nonatomic ,assign) BOOL isButtonClicked;
@property (nonatomic ,assign) BOOL isSystemBoardShow;
@end

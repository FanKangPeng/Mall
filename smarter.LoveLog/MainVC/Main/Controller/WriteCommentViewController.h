//
//  WriteCommentViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/26.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import <EDStarRating.h>
#import "FaceBoard.h"
#import "FKPTextView.h"
@interface WriteCommentViewController : SecondBaseViewController<UITextViewDelegate,EDStarRatingProtocol,FKPTextViewDelegate>
/**产品ID*/
@property (nonatomic ,copy) NSString *good_id;
/**comment UITextView*/
@property (nonatomic ,strong) UITextView *commentTextView;
/**星级描述*/
@property (nonatomic ,strong) UILabel *rangLabel;
/**rating*/
@property (nonatomic ,strong) EDStarRating *ratingView;
/**rating_selected*/
@property (nonatomic ,copy) NSString *ratingCount;

@property (nonatomic ,strong) FKPTextView *commeunityTextView;
@property (nonatomic ,assign) BOOL isShowKeyBoard;
@property (nonatomic ,assign) BOOL isButtonClicked;
@property (nonatomic ,assign) BOOL isSystemBoardShow;
@end

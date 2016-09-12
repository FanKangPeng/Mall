//
//  WritePostsViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "ZLPhotoActionSheet.h"

@interface WritePostsViewController : SecondBaseViewController<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,strong)UIView * tabView;
@property(nonatomic,strong)UIView * writeView;
@property(nonatomic,strong)UITextView * contentTextView;
@property(nonatomic,strong)UIButton * chanceImageButton;
@property(nonatomic,strong)UIButton * keyboardButton;
@property(nonatomic,strong)ZLPhotoActionSheet *actionSheet;
@property(nonatomic,strong)NSString * titleString;
@property(nonatomic,strong)NSMutableArray * contentArr;
@property(nonatomic,strong)NSMutableArray * tempPhotoArr;
@property(nonatomic,copy)void(^writeVCBlock)();

@end

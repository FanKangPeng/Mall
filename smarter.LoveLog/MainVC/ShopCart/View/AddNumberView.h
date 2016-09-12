//
//  AddNumberView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNumberViewDelegate;

@interface AddNumberView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *jianBtn;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UITextField *numberLab;

@property (nonatomic,copy) NSString *numberString;

@property (nonatomic,assign) id<AddNumberViewDelegate> delegate;
@end
@protocol AddNumberViewDelegate <NSObject>

@optional


- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view;

- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view;

-(void)textFileBeginEditDelegate:(UITextField*)textField;

-(void)textFileEndEditDelegate:(UITextField*)textField;
@end
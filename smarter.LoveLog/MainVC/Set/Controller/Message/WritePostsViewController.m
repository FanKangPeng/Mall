//
//  WritePostsViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/28.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "WritePostsViewController.h"
#import "UserInfoTool.h"

@interface WritePostsViewController ()

@end

@implementation WritePostsViewController
#pragma mark - life Cycle
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor =NavigationBackgroundColor;
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:BackgroundColor];
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"发帖" andBack:@"icon_back.png" andRightName:@"发布"];
     __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
        
        double delayInSeconds =[firstResponderView isFirstResponder] ? 1.0 :0;
        [self.view endEditing:YES];

        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lcNavigationController popViewController];
        });
    };
    NavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf fatie];
    };
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentArr  = [NSMutableArray array];
    self.tempPhotoArr = [NSMutableArray array];
    [self.view addSubview:NavigationView];
    [self.view bringSubviewToFront:NavigationView];
    [self.view addSubview:self.tabView];
    [self.view bringSubviewToFront:self.tabView];
    [self.view addSubview:self.titleTextField];
    [self.view sendSubviewToBack:self.titleTextField];
    [self.view addSubview:self.contentTextView];
    [self.view sendSubviewToBack:self.contentTextView];
    
    _actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    _actionSheet.maxSelectCount = 20;
    //设置照片最大预览数
    _actionSheet.maxPreviewCount = 20;
    [self AddObserverForKeyboard];
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    _contentTextView.attributedText = nil;
    _contentTextView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark ---发贴
-(void)fatie
{
    
    
    
    [self.view endEditing:YES];
    
    
    NSTextStorage *ts = [[NSTextStorage alloc] initWithAttributedString:[self.contentTextView.attributedText copy]];
  
    
    [ts enumerateAttribute:NSAttachmentAttributeName
                   inRange:NSMakeRange(0, ts.length)
                   options:0
                usingBlock:^(id value, NSRange range, BOOL *stop)
     {
      
         if (value) {
             //图片
             if (self.tempPhotoArr.count>0) {
                 
                 NSData *dataObj = UIImageJPEGRepresentation(self.tempPhotoArr[0],0.2);
                 if([dataObj length]>0){
                     NSString * baseStr = [dataObj base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                 
                 [self.contentArr addObject:baseStr];
                 
                 [self.tempPhotoArr removeObjectAtIndex:0];
                 }
             }
           
         }else {
             //文字
             // . @"\U0000fffc" 是 NSTextAttachment 的占位符
      
             if (range.location + range.length <= self.contentTextView.text.length) {
                 NSString *text = [self.contentTextView.text substringWithRange:range];
                text= [text stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
                 text= [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                 if (text.length > 0) {
                    [self.contentArr addObject:text];
                 }
             }
         }
         
         if (range.length + range.location == self.contentTextView.text.length) {
             NSLog(@"end");
             [self pushContentArr];
           
         }
     }];
}
-(void)pushContentArr
{
    __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.color  =[UIColor clearColor];
    hud.mode= MBProgressHUDModeCustomView;
    hud.customView = [[LoadGIF_M alloc] init];
    [hud show:YES];
    [UserInfoTool userInfo:@"/post/add" params:@{@"title":self.titleString ? self.titleString : @"",@"content":self.contentArr} success:^(id obj) {

        HUDSHOW([obj objectForKey:@"message"]);
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.lcNavigationController popViewControllerCompletion:^{
                _writeVCBlock();
            }];
        });
    } failure:^(id obj) {
        [hud hide:YES];
        
        if ([obj isKindOfClass:[NSError class]]) {
            
            NSError * err = obj;
            HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
        else
        { 
            if ([[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1000]] ||[[obj objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithLong:1001]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogIn object:nil];
                
            }
            else
                  HUDSHOW([obj objectForKey:@"error_desc"]);
         
        }

      
        
    }];
}


#pragma mark  -- keyboard
-(void)AddObserverForKeyboard
{
    UITapGestureRecognizer * dismissKeyBoardtap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardtapClick:)];
    [self.view addGestureRecognizer:dismissKeyBoardtap];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if ([self.contentTextView isFirstResponder]) {
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        
        NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        [UIView animateWithDuration:animationDuration animations:^{
            self.titleTextField.top = 0;
            self.contentTextView.top =kNavigationHeight +KLeft;
            self.contentTextView.height = kScreenHeight -self.contentTextView.top- keyboardRect.size.height - kBottomBarHeight-KLeft;
            self.tabView.top = self.contentTextView.bottom+KLeft;
        }];
      
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    if ([self.contentTextView isFirstResponder]) {
        NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view endEditing:YES];
            self.titleTextField.top = kNavigationHeight +KLeft;
            self.contentTextView.top =self.titleTextField.bottom+KLeft;
            self.contentTextView.height = kScreenHeight - _titleTextField.bottom -kBottomBarHeight-KLeft*2;
            self.tabView.top = kScreenHeight-kBottomBarHeight;
        }];
    }
}
-(void)dismissKeyBoardtapClick:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
#pragma mark -methods
-(void)chanceImageButton:(UIButton*)button
{
    [self.view endEditing:YES];
    CGFloat imageWidth = kScreenWidth -KLeft*3;
    
    [_actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        
        for (int i = 0 ; i < selectPhotos.count; i++) {
            [self.tempPhotoArr addObject:selectPhotos[i]];
            //            NSRange  rang = [self.contentString rangeOfString:self.contentTextView.text];
            //            self.contentString = [self.contentString stringByAppendingString:[self.contentTextView.text substringWithRange:NSMakeRange(rang.length, self.contentTextView.text.length)]];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
            
            textAttachment.image =selectPhotos[i];
            textAttachment.bounds = CGRectMake(0, 0, imageWidth, textAttachment.image.size.height*imageWidth/textAttachment.image.size.width);
            
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
            NSRange range = [self.contentTextView selectedRange];
            [string insertAttributedString:textAttachmentString atIndex:range.location];//为用户指定要插入图片的位置
            
            self.contentTextView.attributedText = string;
            
            
            
        }
        //插入图片完成后 字体颜色以及换行处理
        [self.contentTextView becomeFirstResponder];
        
        NSString *huanhuang =@"\n";
        NSAttributedString  * huanhangstr =[[NSAttributedString alloc] initWithString:huanhuang];
        NSMutableAttributedString *textViewstring = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
        NSRange range = [self.contentTextView selectedRange];
        [textViewstring insertAttributedString:huanhangstr atIndex:range.location];
        
        self.contentTextView.attributedText = textViewstring;
        
        //行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        
        NSRange range11 = [self.contentTextView selectedRange];
        
        [textViewstring addAttributes:attributes range:NSMakeRange(0, range11.location)];
        
        _contentTextView.font = DefaultFontSize(16);
        _contentTextView.textColor = FontColor_black;
    }];
}
#pragma mark - setter and getter
-(UITextField *)titleTextField
{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(KLeft, kNavigationHeight +KLeft, kScreenWidth -KLeft*2, 40)];
        _titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        _titleTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
        [_titleTextField setBackgroundColor:[UIColor whiteColor]];
        _titleTextField.placeholder =@"标题（25字以内）";
        [_titleTextField setValue:DefaultFontSize(15) forKeyPath:@"_placeholderLabel.font"];
        [_titleTextField setValue:FontColor_black forKeyPath:@"_placeholderLabel.textColor"];
        _titleTextField.font =  DefaultFontSize(15);
        _titleTextField.textColor = FontColor_black;
        _titleTextField.delegate =self;
    }
    return _titleTextField;
}
-(UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(KLeft, _titleTextField.bottom +KLeft, _titleTextField.width, kScreenHeight - _titleTextField.bottom -kBottomBarHeight-KLeft*2)];
        _contentTextView.font = DefaultFontSize(16);
        _contentTextView.textColor = FontColor_black;
        [_contentTextView setBackgroundColor:[UIColor whiteColor]];
        _contentTextView.layer.cornerRadius=3;
        _contentTextView.layer.borderWidth =SINGLE_LINE_WIDTH;
        _contentTextView .layer.borderColor =RGBACOLOR(200, 200, 200, 1).CGColor;
        _contentTextView.delegate =self;
        _contentTextView.userInteractionEnabled = NO;
        NSMutableAttributedString *textViewstring = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
        NSString * xxxx = [textViewstring string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        NSDictionary *attributes = @{
                                     
                                     NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     
                                     };
        
        _contentTextView.attributedText  = [[NSAttributedString alloc] initWithString:xxxx attributes:attributes];
        
    }
    return _contentTextView;
}

-(UIView *)tabView
{
    if (!_tabView) {
        _tabView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight- kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        [_tabView setBackgroundColor:[UIColor whiteColor]];
        
        [_tabView addSubview:self.chanceImageButton];
        [_tabView addSubview:self.keyboardButton];
        
    }
    return _tabView;
}
-(UIButton *)chanceImageButton
{
    if (!_chanceImageButton) {
        _chanceImageButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _chanceImageButton.frame =CGRectMake(kScreenWidth-100,5,39,39);
        [_chanceImageButton setImage:[UIImage imageNamed:@"icon_send_pic"] forState:UIControlStateNormal];
        
        [_chanceImageButton addTarget:self action:@selector(chanceImageButton:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _chanceImageButton;
}


-(UIButton *)keyboardButton
{
    if (!_keyboardButton) {
        _keyboardButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _keyboardButton.frame =CGRectMake(kScreenWidth-49,5,39,39);
        [_keyboardButton setImage:[UIImage imageNamed:@"icon_send_keyboard"] forState:UIControlStateNormal];
        
        [_keyboardButton addTarget:self action:@selector(keyboardButton:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _keyboardButton;
}
-(void)keyboardButton:(UIButton*)button
{
    [self.view endEditing:YES];
}

#pragma mark ---  UITextField delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.titleString = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ---- UITextView delegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
  
}
#pragma mark -内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

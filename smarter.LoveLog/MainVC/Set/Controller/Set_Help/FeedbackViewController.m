//
//  FeedbackViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/20.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UserInfoTool.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [_setNavigationView initViewWithTitle:@"意见反馈" andBack:@"icon_back.png" andRightName:@"发送"];
    __WEAK_SELF_YLSLIDE
    _setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lcNavigationController popViewController];
        });
    };
    
    
    
    
    
    
    _setNavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        [weakSelf sendFeedBack];
    };
    [self.view addSubview:_setNavigationView];
    [self AddObserverForKeyboard];
    
    _titleArr=@[@"反馈主题",@"反馈内容",@"联系方式"];
    [self.view addSubview:self.tableView];
}
-(void)sendFeedBack
{
    [self.view endEditing:YES];
    
    if ([self opinionContent]) {
        [UserInfoTool userInfo:@"/feedback" params:@{@"title":self.titleTextField.text,@"content":self.contentTextView.text,@"contact":self.numberTextField.text} success:^(id obj) {
            HUDSHOW([obj objectForKey:@"message"]);
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.lcNavigationController popViewController];
            });
          
        } failure:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                NSError * err = obj;
                HUDSHOW([err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
            else
                HUDSHOW([obj objectForKey:@"error_desc"]);

        }];
    }
}
-(BOOL)opinionContent
{
    BOOL jiesu =  YES;
    if (![self.contentTextView.text isEqualToString:@"请输入您反馈的内容(必填)"]) {
        if (self.contentTextView.text.length==0) {
            HUDSHOW(@"请输入您反馈的内容");
            jiesu= NO;
        }
        else
            jiesu= YES;
    }
    else
    {
        jiesu= NO;
    }
    
    
    
    if (_numberTextField.text.length==0) {
         HUDSHOW(@"请输入您的手机号或邮箱");
        jiesu= NO;
    }
    else
        jiesu= YES;
    
    return jiesu;
}
#pragma mark --- keyboard
-(void)AddObserverForKeyboard
{
    UITapGestureRecognizer * dismissKeyBoardtap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardtapClick:)];
    [self.view addGestureRecognizer:dismissKeyBoardtap];
    
}
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:view];
 
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView.scrollEnabled =NO;
    }
    return _tableView;
}
-(UITextField *)titleTextField
{
    if (!_titleTextField) {
        _titleTextField =[[UITextField alloc] initWithFrame:CGRectMake(KLeft,0, kScreenWidth, 45)];
        _titleTextField.borderStyle=UITextBorderStyleNone;
        [_titleTextField setBackgroundColor:[UIColor whiteColor]];
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.font = DefaultFontSize(15);
        _titleTextField.delegate =self;
        _titleTextField.tag =300;
        _titleTextField.placeholder=@"请输入您反馈的主题(选填)";
        [_titleTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    }
    return _titleTextField;
}
-(UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField =[[UITextField alloc] initWithFrame:CGRectMake(KLeft,0, kScreenWidth, 45)];
        _numberTextField.borderStyle=UITextBorderStyleNone;
        [_numberTextField setBackgroundColor:[UIColor whiteColor]];
        _numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberTextField.font = DefaultFontSize(15);
        _numberTextField.delegate =self;
        _numberTextField.tag =400;
        _numberTextField.placeholder=@"请输入您的手机号或邮箱(必填)";
        [_numberTextField setValue:DefaultFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    }
    return _numberTextField;
}
-(UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView =[[UITextView alloc] initWithFrame:CGRectMake(KLeft,0, kScreenWidth, 110)];
        [_contentTextView setBackgroundColor:[UIColor whiteColor]];
        _contentTextView.font = DefaultFontSize(14);
        _contentTextView.delegate =self;
        _contentTextView.tag =400;
        _contentTextView.text=@"请输入您反馈的内容(必填)";
        _contentTextView.textColor = FontColor_lightGary;
     
    }
    return _contentTextView;
}
#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [view setBackgroundColor:BackgroundColor];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLeft, KLeft, 200, KLeft*2)];
    titleLabel.text = _titleArr[section];
    titleLabel.font =DefaultFontSize(15);
    titleLabel.textColor = FontColor_black;
    [view addSubview:titleLabel];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:self.titleTextField];
            break;
        case 1:
            [cell.contentView addSubview:self.contentTextView];
            break;
        case 2:
            [cell.contentView addSubview:self.numberTextField];
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(void)buttonClick:(UIButton*)button
{
    if(button.selected)
        button.selected=NO;
    else
        button.selected =YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 ||indexPath.section==2) {
        return 45;
    }
    else
        return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect: textField.bounds toView:window];
    if(rect.origin.y    >  kScreenHeight - 300)
    {
        
        [UIView  animateWithDuration:1 animations:^{
            self.tableView.contentOffset = CGPointMake(0, rect.origin.y-300);
            
            
        } completion:^(BOOL finished) {
        }];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
  
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.tableView.contentOffset.y>100)
    {
        [UIView  animateWithDuration:0 animations:^{
            self.tableView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
        }];
    }
    [textField resignFirstResponder];
}
-(void)dismissKeyBoardtapClick:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView

{
    
    //    textview 改变字体的行间距
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.textColor= FontColor_black;
    textView.font= DefaultFontSize(15);
    textView.text=@"";
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length==0) {
        textView.font = DefaultFontSize(14);
        textView.text=@"请输入您反馈的内容(必填)";
        textView.textColor = FontColor_lightGary;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
   
}

@end

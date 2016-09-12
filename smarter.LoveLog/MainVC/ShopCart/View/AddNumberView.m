//
//  AddNumberView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/23.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AddNumberView.h"

@implementation AddNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{

    
    self.jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jianBtn.frame = CGRectMake(0,0, 25, 25);
    self.jianBtn.tag = 12;
    
//    [self.jianBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.jianBtn setBackgroundImage:[UIImage imageNamed:@"syncart_less_btn_enable"] forState:0];
   [self.jianBtn setBackgroundImage:[UIImage imageNamed:@"syncart_less_btn_disable"] forState:UIControlStateDisabled];
    [self.jianBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.jianBtn setTitle:@"-" forState:0];
//    [self.jianBtn setTitleColor:[UIColor blackColor] forState:0];
//    self.jianBtn.titleLabel.font = DefaultFontSize(20);
//    [self.jianBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, 5, 5, 5)];
//    self.jianBtn.layer.borderColor = BackgroundColor.CGColor;
//    self.jianBtn.layer.borderWidth = SINGLE_LINE_WIDTH;
    [self addSubview:self.jianBtn];
    _jianBtn.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .widthIs(30)
    .heightIs(30);
    
    
    //15:180  960
    self.numberLab = [[UITextField alloc]init];

   [self.numberLab setBackground:[[UIImage imageNamed:@"syncart_middle_btn_enable"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.keyboardType=UIKeyboardTypeNumberPad;
    self.numberLab.textColor = [UIColor blackColor];
    self.numberLab.font = DefaultFontSize(15);
    self.numberLab.delegate =self;
//    self.numberLab.layer.borderColor = RGBACOLOR(0, 0, 0, 0.6).CGColor;
//    self.numberLab.layer.borderWidth = SINGLE_LINE_WIDTH * 1.3;
    [self.numberLab addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.numberLab];
    
    _numberLab.sd_layout
    .leftSpaceToView(self.jianBtn,0)
    .topEqualToView(self.jianBtn)
    .widthIs(48)
    .heightIs(30);
    
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.tag = 11;
    
    //    [self.addBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"syncart_more_btn_enable"] forState:0];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"syncart_more_btn_disable"] forState: UIControlStateDisabled];
    //
    //    [self.addBtn setTitle:@"+" forState:0];
    //    [self.addBtn setTitleColor:[UIColor blackColor] forState:0];
    //    self.addBtn.titleLabel.font = DefaultFontSize(20);
    //    [self.addBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 5, 5)];
    //
    //    self.addBtn.layer.borderColor = BackgroundColor.CGColor;
    //    self.addBtn.layer.borderWidth = SINGLE_LINE_WIDTH;
    
    
    
    [self addSubview:self.addBtn];
    _addBtn.sd_layout
    .leftSpaceToView(_numberLab,0)
    .topSpaceToView(self,0)
    .widthIs(30)
    .heightIs(30);
    

    
    

    
}
-(void)textFieldValueChanged:(UITextField*)textFiedl
{
  
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView * tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [tabView setBackgroundColor:BackgroundColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-60, 5, 60, 30);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [tabView addSubview:btn];
    
    
    
    

    [textField setInputAccessoryView:tabView];
    
    
    
    [self.delegate textFileBeginEditDelegate:textField];
    return YES;
}
-(void)dismissKeyBoard
{
    [self.numberLab  resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
 
    
    if ([textField.text intValue] < 5) {
        HUDSHOW(@"亲，宝贝不能再减少了哦");
        textField.text=@"5";
        
      
    }

    [self.delegate textFileEndEditDelegate:textField];
     [textField resignFirstResponder];
    return YES;
   
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text intValue] < 5) {
        HUDSHOW(@"亲，宝贝不能再减少了哦");
        textField.text=@"5";
        
    }

    [self.delegate textFileEndEditDelegate:textField];
    [textField resignFirstResponder];
    return YES;

}
-(void)setNumberString:(NSString *)numberString{
    
    _numberString = numberString;
   
    
    self.numberLab.text = numberString;
  
}


- (void)deleteBtnAction:(UIButton *)sender {
    
    NSLog(@"减方法");
    
    if ([self.numberLab.text intValue] <= 5) {
        HUDSHOW(@"亲，宝贝不能再减少了哦");
        self.numberLab.text=@"5";
        
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnAction:addNumberView:)]){
        
        [self.delegate deleteBtnAction:sender addNumberView:self];
    }
    
    
}

- (void)addBtnAction:(UIButton *)sender {
    
    NSLog(@"加方法");
    if(self.delegate && [self.delegate respondsToSelector:@selector(addBtnAction:addNumberView:)]){
        
        [self.delegate addBtnAction:sender addNumberView:self];
    }
    
}




@end

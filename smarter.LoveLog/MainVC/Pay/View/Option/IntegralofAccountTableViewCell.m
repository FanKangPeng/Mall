//
//  IntegralofAccountTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/17.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "IntegralofAccountTableViewCell.h"

@implementation IntegralofAccountTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = DefaultFontSize(15);
        [self.contentView addSubview:self.swithBtn];
        [self.contentView addSubview:self.editView];
        [self.editView setHidden:YES];
    }
    return self;
}
- (void)setIntegralDict:(NSDictionary *)integralDict
{
    _integralDict  = integralDict;
    NSString *user_integral = [integralDict objectForKey:@"user_integral"];
    NSNumber *order_max_integral = [integralDict objectForKey:@"order_max_integral"];
    
    _TextField1.text = user_integral;
    if ([order_max_integral floatValue] <= 0) {
        self.userInteractionEnabled = false;
        self.textLabel.text = @"此订单不可使用积分!";
    }else
    {
        if ([user_integral floatValue] > 0) {
            self.userInteractionEnabled = true;
            self.textLabel.text = [NSString stringWithFormat:@"可用积分%@",user_integral];
        }
        else
        {
            self.textLabel.text = @"无可用积分!";
            self.userInteractionEnabled = false;
        }
        
        
        
    }
    
}
- (void)setResult:(id)result
{
    _result = result;
    [self.TextField1  resignFirstResponder];
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:result];
    NSDictionary *data = [dict objectForKey:@"data"];
    self.textLabel.text = [NSString stringWithFormat:@"使用%@积分，抵%@",[data objectForKey:@"used_integral"],[data objectForKey:@"deductible_amount"]];
    [_editView setHidden:true];
    [self.textLabel setHidden:false];
    [_swithBtn setOn:false];
    // 传递积分兑换金额
    _UsedIntegralBlock(@{@"积分抵扣":[NSString stringWithFormat:@"-%@",[data objectForKey:@"deductible_amount"]]});
    
}
- (UISwitch *)swithBtn
{
    if (!_swithBtn) {
        _swithBtn = [[UISwitch alloc] init];
        _swithBtn.frame = CGRectMake(kScreenWidth-55, 7, 45, 23);
        [_swithBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _swithBtn;
}
- (UIView *)editView
{
    if (!_editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(KLeft, 7, kScreenWidth - 80, 30)];
        [_editView setBackgroundColor:[UIColor clearColor]];
        [_editView addSubview:self.Lb1];
        [_editView addSubview:self.Lb2];
        [_editView addSubview:self.TextField1];
    }
    return _editView;
}
- (UILabel *)Lb1
{
    if (!_Lb1) {
        _Lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        _Lb1.text = @"使用";
        _Lb1.font = DefaultFontSize(15);
    }
    return _Lb1;
}
- (UILabel *)Lb2
{
    if (!_Lb2) {
        _Lb2 = [[UILabel alloc] initWithFrame:CGRectMake(93, 0, 45, 30)];
        _Lb2.text = @"积分";
        _Lb2.font = DefaultFontSize(15);
    }
    return _Lb2;
}

- (UITextField *)TextField1
{
    __WEAK_SELF_YLSLIDE
    if (!_TextField1) {
        _TextField1 = [[UITextField alloc] initWithFrame:CGRectMake(35, 3, 55, 24)];
        _TextField1.textColor = NavigationBackgroundColor;
        _TextField1.font = DefaultFontSize(15);
        _TextField1.delegate = self;
        _TextField1.textAlignment = NSTextAlignmentCenter;
        _TextField1.layer.cornerRadius = 2;
        _TextField1.layer.masksToBounds = YES;
        _TextField1.layer.borderColor = FontColor_lightGary.CGColor;
        _TextField1.layer.borderWidth = SINGLE_LINE_WIDTH;
        _TextField1.keyboardType = UIKeyboardTypeNumberPad;
        [_TextField1 addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _TextField1;
}
- (void)buttonClick:(UISwitch*)sender
{
    if (sender.isOn) {
        [self.textLabel setHidden:YES];
        [self.editView setHidden:NO];
    }else
    {
        [self.textLabel setHidden:NO];
        [self.editView setHidden:YES];
        [_TextField1 resignFirstResponder];
        _UnUsedIntegralBlock();
    }
}

-(void)dismissKeyBoard
{
    [self.TextField1  resignFirstResponder];
}
- (void)queren
{
    self.IntegralBlock(_TextField1.text);
}
- (void)textFieldValueChange:(UITextField*)textField
{
   
    NSInteger  value = [textField.text integerValue];
    if (value  < 0  ) {
        textField.text  = @"0";
    }
    if (value > [[_integralDict objectForKey:@"user_integral"] integerValue]) {
        textField.text = [_integralDict objectForKey:@"user_integral"] ;
    }
    else
    {
        NSNumber * number = [_integralDict objectForKey:@"order_max_integral"];
        if (value > [number integerValue]) {
            textField.text = [NSString stringWithFormat:@"%@",number];
        }
    }
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView * tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [tabView setBackgroundColor:BackgroundColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-60, 5, 60, 30);
    [btn addTarget:self action:@selector(queren) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [tabView addSubview:btn];
    
    
    UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt1.frame = CGRectMake(0, 5, 60, 30);
    [bt1 addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [bt1 setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
    [bt1 setTitle:@"取消" forState:UIControlStateNormal];
    [tabView addSubview:bt1];
    
    
    [textField setInputAccessoryView:tabView];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self validateNumber:string];
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end

//
//  MessageTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        UITextField * textfield =[[UITextField alloc] initWithFrame:CGRectMake(KLeft, 8, kScreenWidth-KLeft*2, 35)];
        textfield.borderStyle=UITextBorderStyleRoundedRect;
        textfield.font = DefaultFontSize(13);
        [textfield setValue:DefaultFontSize(13) forKeyPath:@"_placeholderLabel.font"];
        textfield.placeholder=@"留言（选填、45字以内）";
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.delegate=self;
        [self.contentView addSubview:textfield];
       
    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _messageBlock(textField.text);
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _messageBlock(textField.text);
    [textField resignFirstResponder];
    return YES;
}
@end

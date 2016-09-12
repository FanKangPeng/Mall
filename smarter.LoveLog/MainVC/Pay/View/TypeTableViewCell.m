//
//  TypeTableViewCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/5/16.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "TypeTableViewCell.h"
#import "ExpressageModel.h"
#import "PaymentMethod.h"
@implementation TypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.typeIcon];
        _typeIcon.sd_layout
        .leftSpaceToView(self.contentView ,KLeft)
        .topSpaceToView(self.contentView,12)
        .heightIs(16)
        .widthIs(18);
        
        [self.contentView addSubview:self.typeLb];
        _typeLb.sd_layout
        .leftSpaceToView(_typeIcon ,5)
       .topSpaceToView(self.contentView,10)
        .heightIs(20)
        .widthIs(200);
        
    }
    return self;
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    _typeIcon.image = [dataDict objectForKey:@"icon"];
    _typeLb.text = [dataDict objectForKey:@"title"];
    
    
    NSArray * list  = [dataDict objectForKey:@"list"];
    //构建按钮的title
    NSMutableArray * titleArr = [NSMutableArray array];
    if ([[dataDict objectForKey:@"title"] isEqualToString:@"配送方式"]) {
        [titleArr removeAllObjects];
        for (int i = 0 ; i < list.count ; i++) {
            ExpressageModel * model = list[i];
            [titleArr addObject:model.shipping_name];
        }
    }
    
    if ([[dataDict objectForKey:@"title"] isEqualToString:@"支付方式"]) {
        [titleArr removeAllObjects];
        for (int i = 0 ; i < list.count ; i++) {
            PaymentMethod * model = list[i];
            [titleArr addObject:model.name];
        }
    }

        for (int i = 0 ; i < titleArr.count ; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(KLeft + i*90 + KLeft * i  , 40, 90, 35);
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.borderWidth = SINGLE_LINE_WIDTH;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.font =  DefaultFontSize(14);
            [btn setTitle:titleArr[i] forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
            btn.tag = 100 + i;
            
            //设置默认按钮 状态
            if (i == 0) {
                btnTag = btn.tag;
                btn.selected =  YES;
//                NSString * title = btn.titleLabel.text;
//                [btn setImage:[UIImage imageNamed:@"flight_radio_select"] forState:0];
//                [btn setTitle:title forState:0];
//                [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 70)];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, -45, 5, 5)];
                [btn setTitleColor:NavigationBackgroundColor forState:0];
                btn.layer.borderColor = NavigationBackgroundColor.CGColor;
            }
        }
}



- (void)btnClick:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
    }

    if (sender.selected) {
        
        UIButton * lastBtn = (UIButton *)[self viewWithTag:btnTag];
//        NSString * lastBtnTitle = lastBtn.titleLabel.text;
//        [lastBtn setTitle:lastBtnTitle forState:0];
        [lastBtn setTitleColor:[UIColor blackColor] forState:0];
        lastBtn.layer.borderColor = [UIColor blackColor].CGColor;
//        [lastBtn setImage:nil forState:0];
//        [lastBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [lastBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        NSString * title = sender.titleLabel.text;
//        [sender setImage:[UIImage imageNamed:@"flight_radio_select"] forState:0];
//        [sender setTitle:title forState:0];
//        [sender setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 70)];
//        [sender setTitleEdgeInsets:UIEdgeInsetsMake(5, -45, 5, 5)];
        [sender setTitleColor:NavigationBackgroundColor forState:0];
        sender.layer.borderColor = NavigationBackgroundColor.CGColor;
        
        btnTag = sender.tag;
        self.cellBlock(self.tag,sender.tag-100,title);
    }
}






#pragma mark - setter and getter

- (UIImageView *)typeIcon
{
    if (!_typeIcon) {
        _typeIcon = [UIImageView new];
    }
    return _typeIcon;
}
- (UILabel *)typeLb
{
    if (!_typeLb) {
        _typeLb = [UILabel new];
        _typeLb.font = DefaultFontSize(14);
    }
    return _typeLb;
}
- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [UILabel new];
        _contentLb.font = DefaultFontSize(14);
    }
    return _contentLb;
}
@end

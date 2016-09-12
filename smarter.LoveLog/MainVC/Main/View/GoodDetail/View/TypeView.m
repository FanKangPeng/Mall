//
//  TypeView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/4/7.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "TypeView.h"

@implementation TypeView

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)arr title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        lab.text = title;
        lab.textColor = FontColor_black;
        lab.font = DefaultFontSize(14);
        [self addSubview:lab];
        
        BOOL  isLineReturn = NO;
        float upX = 10;
        float upY = 40;
        for (int i = 0; i<arr.count; i++) {
            NSString *str = [arr objectAtIndex:i] ;
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [str sizeWithAttributes:dic];
            if ( upX > (self.frame.size.width-20 -size.width-35)) {
                
                isLineReturn = YES;
                upX = 10;
                upY += 30;
            }
            
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(upX, upY, size.width+30,25);
            [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] size:CGSizeMake(size.width+30, 25)] forState:0];
            [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(size.width+30, 25)] forState:UIControlStateSelected];
            [btn setTitleColor:FontColor_black forState:0];
         //   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = DefaultFontSize(13);
            [btn setTitle:[arr objectAtIndex:i] forState:0];
            btn.layer.cornerRadius = 8;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            btn.layer.borderWidth = 0;
            [btn.layer setMasksToBounds:YES];
            
            [self addSubview:btn];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
            upX+=size.width+35;
            if (i == 0) {
                btn.selected = YES;
                self.selectedIndex = btn.tag -100;
                btn.layer.borderColor = [UIColor redColor].CGColor;
                
                btn.layer.borderWidth = 1;
                
            }
        }
        
       
        
        upY +=30;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, upY+10, self.frame.size.width, SINGLE_LINE_WIDTH)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        self.typeViewHeight = upY+11;
        
      

        
    }
    return self;
}

-(void)touchbtn:(UIButton *)btn
{
    
    if (btn.selected == NO) {
        
        self.selectedIndex = (int)btn.tag-100;
        btn.backgroundColor = NavigationBackgroundColor;

    }else
    {
        self.selectedIndex = -1;
        btn.selected = NO;
       // btn.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
    }
    self.typeViewButtonBlock(btn.tag-100);
}
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}

@end

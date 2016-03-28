//
//  colorViewList.m
//  MyNote
//
//  Created by ft on 16/1/25.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import "ColorView.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation ColorView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //获取上下文
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    //绘制点和路径
    CGContextBeginPath(cr);
    
    //设置线宽
    CGContextSetLineWidth(cr, 0.5);
    
    //把画笔移动到一个点(左上角)
    CGContextMoveToPoint(cr, 10, 0);
    
    //连接到下一个点(右上角)
    CGContextAddLineToPoint(cr, WIDTH - 10, 0);
    
    //再连一个点(右下角)
    CGContextAddLineToPoint(cr, WIDTH - 10, 40);
    
    //连下一个点(下角的右边)
    CGContextAddLineToPoint(cr, WIDTH - 40, 40);
    
    //下一个点(下角的顶角)
    CGContextAddLineToPoint(cr, WIDTH - 50, 55);
    
    //下一个点(下角的左边)
    CGContextAddLineToPoint(cr, WIDTH - 60, 40);
    
    //最后一个点(左下角)
    CGContextAddLineToPoint(cr, 10, 40);
    
    
    //闭合路径
    CGContextClosePath(cr);
    
    //设置填充颜色
    CGContextSetFillColorWithColor(cr, [UIColor colorWithWhite:0.9 alpha:0.3].CGColor);
    
    //填充的同时画出路径
    CGContextDrawPath(cr, kCGPathFillStroke);
}

- (instancetype)initWithTarget:(id)target {
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        NSArray *colorArr = @[ [UIColor colorWithRed:200/255.0 green:0 blue:0 alpha:0.7], [UIColor lightGrayColor], [UIColor orangeColor], [UIColor colorWithRed:0 green:200/255.0 blue:0 alpha:0.8], [UIColor colorWithRed:0 green:0 blue:200/255.0 alpha:0.8], [UIColor yellowColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor brownColor], [UIColor colorWithRed:204/255.0 green:178/255.0 blue:153/255.0 alpha:1] ];
    
        //创建颜色button
        for (NSUInteger i = 0; i < 10; ++ i) {
            
            UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 30 * i, 10, 20, 20)];
            colorBtn.backgroundColor = [colorArr objectAtIndex:i];
            colorBtn.layer.cornerRadius = 10;
            [self addSubview:colorBtn];
            [colorBtn addTarget:self action:@selector(colorButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        }
        

        
    }
    return self;
}


- (void)colorButtonPress:(UIButton *)button {
 
    //调用代理方法
    [self.delegate colorChangedWithNewColor:button.backgroundColor];
}


@end

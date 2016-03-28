//
//  UIImage+Scale.m
//  MyNote
//
//  Created by ft on 16/1/3.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import "UIImage+Scale.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation UIImage (Scale)


- (UIImage *)transformToFitSize {
    
    //最大宽为屏幕的宽度
    return  [self transformWithinMaxWidth:WIDTH];
}


- (UIImage *)transformWithinMaxWidth:(CGFloat)width {
    
   //如果图片大小大于设定的最大宽度
    if (self.size.width > width) {
        
        CGSize imgSize;
        //设置图片的宽度
        imgSize.width = width;
        //计算缩放图片的高度
        imgSize.height = self.size.height / self.size.width * width;
        
        //创建一个图片context
        UIGraphicsBeginImageContext(imgSize);
        
        //绘制改变大小的图片
        [self drawInRect:CGRectMake(0, 0, imgSize.width - 10, imgSize.height)];
        
        //从当前context中创建一个改变大小后的图片
        UIImage *transformImg = UIGraphicsGetImageFromCurrentImageContext();
        
        //使用当前的context出堆栈
        UIGraphicsEndImageContext();
        
        //返回绘制的图片
        return transformImg;
    }else {
        
        //返回本身
        return self;
    }
}

@end

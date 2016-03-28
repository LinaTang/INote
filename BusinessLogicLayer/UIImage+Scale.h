//
//  UIImage+Scale.h
//  MyNote
//
//  Created by ft on 16/1/3.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)


- (UIImage *)transformToFitSize;

- (UIImage *)transformWithinMaxWidth:(CGFloat)width;


@end

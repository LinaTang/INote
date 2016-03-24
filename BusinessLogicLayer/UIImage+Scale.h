//
//  UIImage+Scale.h
//  MyNote
//
//  Created by Ibokan on 16/1/3.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)


- (UIImage *)transformToFitSize;

- (UIImage *)transformWithinMaxWidth:(CGFloat)width;


@end

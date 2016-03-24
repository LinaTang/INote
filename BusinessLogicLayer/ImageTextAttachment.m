//
//  ImageTextAttachment.m
//  MyNote
//
//  Created by Ibokan on 16/1/3.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "ImageTextAttachment.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ImageTextAttachment

#pragma mark - NSTextAttachmentContainer的代理方法
//暂未清楚其作用
//- (UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex {
//   
//}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
 
//    CGSize imgSize;     //记录显示在textView上的imageSize
//    if (self.image.size.width > WIDTH) {
//        imgSize.width = WIDTH;
//    }else {
//        imgSize.width = self.image.size.width;
//    }
//    
//    imgSize.height = self.image.size.height / self.image.size.width * imgSize.width;
//
//    return CGRectMake(0, 0, imgSize.width,imgSize.height);
    
    //返回固定大小
    return CGRectMake(0, 0, 250, 100);

}

@end

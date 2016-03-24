//
//  ImageTextAttachment.h
//  MyNote
//
//  Created by Ibokan on 16/1/3.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义图片附件 (本工程暂未使用)
@interface ImageTextAttachment : NSTextAttachment

@property(nonatomic,strong)NSString *imgName;
@property(nonatomic)CGSize imageSize;

@end

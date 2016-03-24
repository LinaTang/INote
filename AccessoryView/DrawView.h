//
//  DrawView.h
//  简易画画2
//
//  Created by Ibokan on 15/12/31.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

//每次触摸之后的view保存的图片(提供外部访问接口)
@property(nonatomic,strong)UIImage *contextImg;

//画笔宽度
@property(nonatomic,assign)CGFloat width;

//画笔颜色
@property(nonatomic,assign)UIColor *penColor;

//画笔样式
@property(nonatomic,assign)CGLineCap lineCap;


@end

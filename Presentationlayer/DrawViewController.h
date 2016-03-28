//
//  DrawViewController.h
//  MyNote
//
//  Created by ft on 16/1/4.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import <UIKit/UIKit.h>

//宏定义
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

/////画图控制器
@interface DrawViewController : UIViewController

///此属性用于返回画图
@property(copy, nonatomic)void (^backBlock)(UIImage *drawImage);


@end

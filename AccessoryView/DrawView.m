//
//  DrawView.m
//  简易画画2
//
//  Created by Ibokan on 15/12/31.
//  Copyright © 2015年 ft. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()
{
    //记录上一次和当前的位置
    CGPoint _lastPoint, _currentPoint;
}
@end

/**
 1.记录下图片开始以及结束的位置,裁剪图片
 */
@implementation DrawView

#if 0 - 不重写此方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //方法一实现画图:添加一个拖动手势
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
//        [self addGestureRecognizer:pan];

#pragma mark - 以下方法可以设置画板的背景颜色
        //新建图片上下文
        UIGraphicsBeginImageContext(self.bounds.size);
     
        //获取当前上下文
        CGContextRef cr = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(cr, [UIColor whiteColor].CGColor);
        //画context的填充颜色
        CGContextFillRect(cr, self.bounds);

        //保存当前的图片上下文
        _contextImg = UIGraphicsGetImageFromCurrentImageContext();
        //结束图片上下文
        UIGraphicsEndImageContext();
    }
    return self;
}
#endif


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //画出图片rext
    [_contextImg drawInRect:rect];
}


//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //获得触摸的第一次位置
    _lastPoint = [[touches anyObject] locationInView:self];
}

//触摸中
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    //新建图片上下文
    UIGraphicsBeginImageContext(self.bounds.size);
    //把原来的图片画在新的上下文中
    [_contextImg drawInRect:self.bounds];
    
    //记录触摸的位置
    _currentPoint = [touch previousLocationInView:self];
    
    //NSLog(@"%@-%@",NSStringFromCGPoint(_lastPoint),NSStringFromCGPoint(_currentPoint));
    //获取当前上下文
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    //设置画笔样式属性(圆头)
    CGContextSetLineCap(cr, _lineCap);
    //设置画笔线宽
    CGContextSetLineWidth(cr, _width);
    //设置画笔颜色属性
    CGContextSetStrokeColorWithColor(cr, _penColor.CGColor);

    //将lastPoint和currentPoint连成线
    CGContextMoveToPoint(cr, _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(cr, _currentPoint.x, _currentPoint.y);
    CGContextStrokePath(cr);
    
    //保存当前的上下文为图片
    _contextImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //将当前的位置给记录下来
    _lastPoint = _currentPoint;
    [self setNeedsDisplay];
}



#if 0

/**
 *  利用手势画图
 *
 *  @param pan 拖动事件
 */

 - (void)panned:(UIPanGestureRecognizer *)pan {
     
     //记录拖动手势的上一个点和当前点
     static CGPoint lastPoint, currentPoint;
     
     switch (pan.state) {
         case UIGestureRecognizerStateBegan:
             //记录上一个点
             lastPoint = [pan locationInView:self];
             break;
             
         case UIGestureRecognizerStateChanged:
         {
             //记录currentPoint
             currentPoint = [pan locationInView:self];
             
             //新建图片上下文
             UIGraphicsBeginImageContext(self.bounds.size);
             
             //把原来的图片画在新的上下文中
             [_contextImg drawInRect:self.bounds];
             
             //获取当前上下文
             CGContextRef cr = UIGraphicsGetCurrentContext();
             
             //设置各种画笔属性
             CGContextSetLineCap(cr, kCGLineCapRound);//圆头画笔
             CGContextSetLineWidth(cr, 2);//画笔线宽
             
             //关键点：设置渲染模式为clear，这样画图时就不是涂颜色，而是把原有的颜色（灰色矩形）抹掉
             //CGContextSetBlendMode(cr, kCGBlendModeClear);
             
             //将lastPoint和currentPoint连成线
             CGContextMoveToPoint(cr, lastPoint.x, lastPoint.y);
             CGContextAddLineToPoint(cr, currentPoint.x, currentPoint.y);
             CGContextStrokePath(cr);
             
             
             //上述的上下文操作将会得出一个被抹掉一笔的矩形
             //它不会在这里显示出来，所以把它保存为图片
             _contextImg = UIGraphicsGetImageFromCurrentImageContext();
             
             //结束图片上下文操作
             UIGraphicsEndImageContext();
             
             //lastPoint变为currentPoint
             lastPoint = currentPoint;
             
             //为了更新的上下文图片能够显示在界面上，调用setNeedDisplay，在drawRect中画图
             [self setNeedsDisplay];
             
         }
             break;
             
         default:
             break;
     }
     
 }

#endif


@end

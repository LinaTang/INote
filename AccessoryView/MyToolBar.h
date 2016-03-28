//
//  myToolBar.h
//  MyNote
//
//  Created by ft on 16/1/15.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorView.h"

//协议<navigationController>作用是:
@interface MyToolBar : UIToolbar <UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


//强引用
@property(strong, nonatomic, readonly)UITextView *textView;

//弱引用(否则可能导致该对象无法被销毁,此处只使用原来的viewController)
@property(weak, nonatomic, readonly)UIViewController<ColorChangeProtocol> *viewController;


/**
 *  设置textField
 *
 *  @param textField      要改变的textView
 *  @param viewController 呈现其它视图的控制器
 */
- (void)setTextView:(UITextView *)textView withViewController:(UIViewController *)viewController;


@end

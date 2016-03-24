//
//  AddViewController.m
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import "AddViewController.h"
#import "Note.h"
#import "NoteBL.h"
#import "MyToolBar.h"
#import "ColorView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface AddViewController () <UITextViewDelegate, ColorChangeProtocol>
{
    Note *_note;
    
    UITextView *_textView;
    
    MyToolBar *_toolBar;
}

@end


/**
 *  添加下滑手势作为改变toolBar的frame值
 */
@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置View标题和背景颜色
    self.title =  @"添加";
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:225/255.0 blue:143/255.0 alpha:1];
    self.navigationController.toolbarHidden = YES;
    
    //设置navigationBar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonClick)];

    
    //初始化textView
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView setFont:[UIFont fontWithName:@"Thonburi" size:18]];
    _textView.alwaysBounceVertical = YES;
    //设置代理人
    _textView.delegate = self;
    
    
    //初始化工具栏
    _toolBar = [[MyToolBar alloc] initWithFrame: CGRectMake(0, HEIGHT - 35, WIDTH, 35)];
    [_toolBar setTextView:_textView withViewController:self];
    [self.view addSubview:_toolBar];
    //设置工具栏是textView的附件栏
//    _textView.inputAccessoryView = _toolBar;
    
    //让textView变成第一响应者(弹出键盘)
    [_textView becomeFirstResponder];

    
    //注册监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


//取消按钮的点击方法
- (void)cancelButtonClick {

    //设置推出本控制器的转场动画
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.2;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

//完成按钮的点击方法
- (void)okButtonClick {

    //如果textField内容为空,则弹出警告框,并且返回
    if ( _textView.attributedText.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        //呈现警告框
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        
        Note *note = [Note noteWithDate:[NSDate date] attributedContent:_textView.attributedText andInfomation:@{ @"color" : self.view.backgroundColor, @"lastModify" : [NSDate date] }];
        NoteBL *noteBL = [NoteBL new];
        //调用代理方法,重新赋值
        [self.delegate getTheNewestListArray:[noteBL createNote:note]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 实现textView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ( scrollView.contentOffset.y < -120 ) {
        [_textView resignFirstResponder];
    }
}


#pragma mark - 实现键盘收到通知的方法

- (void)keyBoardWillShow:(NSNotification *)nf {
    
    //获取键盘的高度
    CGFloat height = [[nf.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //修改文本框的frame
    CGRect newFrame = _textView.frame;
    newFrame.size.height = HEIGHT - height;
    _textView.frame = newFrame;
    
    //修改toolBar的frame
   _toolBar.frame = CGRectMake( 0,  HEIGHT - 35 - height, WIDTH, 35 );
}


- (void)keyBoardWillHide:(NSNotification *)nf {
    
    //恢复文本框的frame值
    _textView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    //恢复toolBar的frame
    _toolBar.frame = CGRectMake(0, HEIGHT - 35, WIDTH, 35);
}

#pragma mark - 实现ColorChangeProtocol的代理协议

- (void)colorChangedWithNewColor:(UIColor *)newColor {
    
    self.view.backgroundColor = newColor;
}


/**
 *  对象销毁调用的方法,注销通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end

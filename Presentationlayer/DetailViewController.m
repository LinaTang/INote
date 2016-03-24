//
//  DetailViewController.m
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteBL.h"
#import "UIImage+Scale.h"
#import "DrawViewController.h"
#import "MyToolBar.h"
#import "ColorView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DetailViewController () <UITextViewDelegate, ColorChangeProtocol>
{
    
    UITextView *_textView;
    
    MyToolBar *_toolBar;
    
    BOOL _isChange;    //判断是否发生编辑(改变属性)
}

//@property(retain, nonatomic)MyToolBar *toolBar;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细内容";
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:225/255.0 blue:143/255.0 alpha:1];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightBarButtonClick)];
    
    
    //初始化textView
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.attributedText = _note.attributedContent;
    //设置代理人
    _textView.delegate = self;
    //设置textView总是可以在竖直方向上滚动的属性
    _textView.alwaysBounceVertical = YES;
    
    //为了兼容之前未设定背景颜色做判断
    UIColor *backgroundColor = [_note.dict objectForKey:@"color"];
    if (backgroundColor) {
        self.view.backgroundColor = backgroundColor;
    }
    
    //设置时间格式
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    //初始化textView一个头信息(显示最后更新的时间)
    UILabel *lastModTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, - 30, WIDTH, 30)];
    [_textView addSubview:lastModTimeLB];
    NSDate *lastTime = [_note.dict objectForKey:@"lastModify"];
    lastModTimeLB.text = [NSString stringWithFormat:@"上次更新时间:%@",[dateFormatter stringFromDate:lastTime]] ;
    lastModTimeLB.font = [UIFont systemFontOfSize:14];
    lastModTimeLB.textColor = [UIColor whiteColor];
    lastModTimeLB.textAlignment = NSTextAlignmentCenter;
    lastModTimeLB.backgroundColor = [UIColor clearColor];
    
    //初始化工具栏
    _toolBar = [[MyToolBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 35, WIDTH, 35)];
    [_toolBar setTextView:_textView withViewController:self];
    [self.view addSubview:_toolBar];
    
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘即将消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


//分享按钮(待实现)
- (void)rightBarButtonClick {
    
    NSLog(@"最后修改时间为:%@",[_note.dict objectForKey:@"lastModify"]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint position = scrollView.contentOffset;
    //NSLog(@"position:%@",NSStringFromCGPoint(position));
    
    //取消textView的第一响应者身份
    if (position.y < -120 ) {
        
        [_textView resignFirstResponder];
    }
    
}



#pragma mark - textView相关的代理方法实现(设置光标)

- (void)textViewDidChange:(UITextView *)textView {
    
    //如果发生编辑,改变编辑状态
    _isChange = YES;
}

#if 0
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    //为了获取首次点击textView时的光标位置
    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];
    
    NSArray *subViews = [self.view subviews];
    NSLog(@"subView:%@",subViews);
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    UITextRange *range = textView.selectedTextRange;
    //光标位置
    CGPoint position = [textView caretRectForPosition:range.start].origin;
    
    NSLog(@"++%@",NSStringFromCGPoint(position));

    //执行textView的滚动操作
    if ( _textView.contentSize.height > _textView.frame.size.height / 4 ) {

//        [_textView setContentOffset:CGPointMake(0, _textView.contentSize.height / 10 + 10 )  animated:NO];
        
//        [_textView scrollRangeToVisible:(NSRange)];
//        [_textView scrollRectToVisible:(CGRect) animated:(BOOL)];
    }
    
    //可设置光标位置的新位置
    //    NSRange newSelectedRang = NSMakeRange(selectedRang.location + 1, 0);
    //    _textView.selectedRange = newSelectedRang;
}

#endif


#pragma mark - 监听键盘调用的方法

- (void)keyBoardWillShow:(NSNotification *)nf {

    NSDictionary *dictInfo = nf.userInfo;
    //获取键盘高度
    CGFloat height = [[dictInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //修改scrollViewframe
    CGRect rect = _textView.frame;
    rect.size.height = HEIGHT - height - 35;
     _textView.frame = rect;
    
    //修改toolBar的frame值
    _toolBar.frame = CGRectMake( 0,  HEIGHT - 35 - height, WIDTH, 35 );
}

- (void)keyBoardWillHide:(NSNotification *)nf {
    
    //恢复scrollView的初始frame
    CGRect rect = _textView.frame;
    rect.size.height = HEIGHT;
    _textView.frame = rect;
    
    //恢复toolBar的frame
    _toolBar.frame = CGRectMake(0, HEIGHT - 35, WIDTH, 35);
}


#pragma mark - 实现ColorChangeProtocol的代理协议

- (void)colorChangedWithNewColor:(UIColor *)newColor {
    
    //如果发生编辑,改变编辑状态
    _isChange = YES;
    
    self.view.backgroundColor = newColor;
}


#pragma mark - dealloc方法 (对象销毁时调用)

-(void)dealloc {

    //如果未编辑note内容则不会重新调用代理,重新刷cell
//    if ( ![_textView.attributedText isEqualToAttributedString:_note.attributedContent] ) {
    if ( _isChange ) {

        NoteBL *noteBL = [NoteBL new];

        //remove掉原来的备忘录
//        [noteBL remove:_note];
        //创建新的备忘录
//        Note *newNote = [Note noteWithDate:[NSDate date] attributedContent:_textView.attributedText andInfomation:@{ @"color" : self.view.backgroundColor }];
//        NSMutableArray *mArr = [noteBL createNote:newNote];
        
        //修改_note的内容
        _note.dict = @{ @"color" : self.view.backgroundColor, @"lastModify" : [NSDate date] };
        _note.attributedContent = _textView.attributedText;
        NSMutableArray *mArr = [noteBL modify:_note];
        
        //判断是否实现了这个协议
        if ( [_delegate respondsToSelector:@selector(getTheNewestListArray:)] ) {
            //调用代理方法,添加新的备忘录
            [_delegate getTheNewestListArray:mArr];
        }
    }
    
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //解除键盘消失通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}



@end

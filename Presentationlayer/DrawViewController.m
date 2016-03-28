//
//  DrawViewController.m
//  MyNote
//
//  Created by ft on 16/1/4.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"

@interface DrawViewController ()
{
    //画布
    DrawView *_drawView;
    
    UIToolbar *_toolBar;
    
    //存放slider的view
    UIView *_sliderView;
    //存放颜色设置的view
    UIView *_colorView;
    
    //记录画布的操作
    NSUndoManager *_undoManager;
}
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /////自定义navigationBar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:navBar];
    navBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1];
    navBar.tintColor = [UIColor orangeColor];
//    [navBar.layer setShadowOffset:CGSizeMake(WIDTH, 5)];
//    navBar.layer.shadowColor = [UIColor blackColor].CGColor;

    //初始化navigationBar的Item
    UINavigationItem *navItems = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPress)];
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(redoButtonPress)];
    UIBarButtonItem *leftItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButtonPress)];
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPress)];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemPress)];
  
    navItems.leftBarButtonItems = @[leftItem1,leftItem2,leftItem3];
    navItems.rightBarButtonItems = @[rightItem1,rightItem2];
    //设置navigatinBar的items
    navBar.items = @[navItems];
    
    /////初始化画布
    _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 144)];
    _drawView.backgroundColor = [UIColor whiteColor];
    _drawView.width = 2;
    _drawView.penColor = [UIColor blackColor];
    _drawView.lineCap = kCGLineCapRound;        //kCGLineCapRound kCGLineCapSquare
    
    [self.view addSubview:_drawView];
    
    
    ////自定义toolbar
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
    _toolBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:_toolBar];

    UIImage *image0_0 = [UIImage imageNamed:@"yuanbi0"];
    UIImage *image1_0 = [UIImage imageNamed:@"labi0"];
    UIImage *image2_0 = [UIImage imageNamed:@"jianbi0"];
    UIImage *image3 = [UIImage imageNamed:@"xiantiao"];
    
    //设置toolBar上的Item
    //button使用的图片格式为原图
    UIBarButtonItem *penStyleItem1 = [[UIBarButtonItem alloc] initWithImage:[image0_0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(penStyleButtonpress:)];
    penStyleItem1.tag = 100;
   
    UIBarButtonItem *penStyleItem2 = [[UIBarButtonItem alloc] initWithImage:[image1_0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(penStyleButtonpress:)];
    penStyleItem2.tag = 101;
    
    UIBarButtonItem *penStyleItem3 = [[UIBarButtonItem alloc] initWithImage:[image2_0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(penStyleButtonpress:)];
    penStyleItem3.tag = 102;

//    UIBarButtonItem *penWidth = [[UIBarButtonItem alloc] initWithTitle:@"宽度" style:UIBarButtonItemStylePlain target:self action:@selector(penWidthButtonPress)];
    UIBarButtonItem *penWidth = [[UIBarButtonItem alloc] initWithImage:[image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(penWidthButtonPress)];
    
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton.frame = CGRectMake(0, 0, 30, 30);
    colorButton.backgroundColor = [UIColor blackColor];
    colorButton.layer.cornerRadius = 15;
    colorButton.tag = 104;
    [colorButton addTarget:self action:@selector(colorButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *penColor = [[UIBarButtonItem alloc] initWithCustomView:colorButton];
   
    //自适应分隔符
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _toolBar.items = @[ flexItem, penStyleItem1, flexItem, penStyleItem2, flexItem, penStyleItem3, flexItem, penWidth, flexItem, penColor ];
    
    
    /////
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
    [self.view addSubview:_sliderView];
    _sliderView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _sliderView.hidden = YES;   //默认为隐藏
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 25)];
    [_sliderView addSubview:label];
    label.center = CGPointMake(CGRectGetWidth(_sliderView.frame) / 2, 15);
    label.text = [NSString stringWithFormat:@"线条宽度%.1f",_drawView.width];
    label.tag = 110;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 30, 220, 25)];
    [_sliderView addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.value = _drawView.width;
    slider.minimumValue = 1;
    slider.maximumValue  = 60;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 30, 40, 30)];
    [backBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_sliderView addSubview:backBtn];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    //////
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
    [self.view addSubview:_colorView];
    _colorView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _colorView.hidden = YES;   //默认为隐藏
  
    NSArray *colorArr = @[ [UIColor blackColor], [UIColor lightGrayColor], [UIColor orangeColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor brownColor] ];

    CGFloat colorViewWidth = CGRectGetWidth(_colorView.frame);
    
    for ( NSInteger i = 0; i < 10; ++ i ) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( 18 +  colorViewWidth / 5 * (i % 5) ,    5 + (i / 5) * 40 , 30, 30)];
        [_colorView addSubview:button];
        //设置圆角
        button.layer.cornerRadius = 15;
        button.backgroundColor = [colorArr objectAtIndex:i];
        [button addTarget:self action:@selector(subColorButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //////初始化undoManager
    _undoManager = [NSUndoManager new];
}

#pragma mark - navigationBarItem点击的事件处理
/////写demo
- (void)redoButtonPress {
    
//    _drawView.width = 10;
}

- (void)undoButtonPress {
    
//    _drawView.penColor = [UIColor purpleColor];
}

- (void)actionButtonPress {
    
//    _drawView.lineCap = kCGLineCapRound;
}


- (void)doneButtonPress {
    
    //调用代码块,返回画图
    self.backBlock(_drawView.contextImg);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelItemPress {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - toolBar的barButtonItem点击事件的处理

- (void)penStyleButtonpress:(UIBarButtonItem *)buttonItem {

    //当前画笔的lineCap属性
    CGLineCap lastLineCap = _drawView.lineCap;
    
    //设置画笔属性
    if (buttonItem.tag == 100 || lastLineCap == kCGLineCapRound ) {
        
        if ( buttonItem.tag == 100 ) {
            //若选中当前画笔,改变drawView画笔的属性
            _drawView.lineCap = kCGLineCapRound;
            buttonItem.image = [[UIImage imageNamed:@"yuanbi0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            //获取第一支画笔
            UIBarButtonItem *barButton = [_toolBar.items objectAtIndex:1];
            //上次为此画笔,本次非此画笔,则把此画笔值为原始背景
            barButton.image = [[UIImage imageNamed:@"yuanbi1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

    }
    if (buttonItem.tag == 101 || lastLineCap == kCGLineCapButt) {

        
        if ( buttonItem.tag == 101 ) {
             _drawView.lineCap = kCGLineCapButt;
            buttonItem.image = [[UIImage imageNamed:@"labi1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            //获取第二支画笔
            UIBarButtonItem *barButton = [_toolBar.items objectAtIndex:3];
            barButton.image = [[UIImage imageNamed:@"labi0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
       
    }
    if (buttonItem.tag == 102 || lastLineCap == kCGLineCapSquare) {

        //
        if ( buttonItem.tag == 102 ) {
            _drawView.lineCap = kCGLineCapSquare;
            buttonItem.image = [[UIImage imageNamed:@"jianbi1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            //获取第三支画笔
            UIBarButtonItem *barButton = [_toolBar.items objectAtIndex:5];
            barButton.image = [[UIImage imageNamed:@"jianbi0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

    }

    
}

- (void)penWidthButtonPress {
    
    //呈现滑块视图
    _sliderView.hidden = NO;
}



- (void)colorButtonPress {
    
    //呈现颜色视图
    _colorView.hidden = NO;
}


#pragma mark - 其它事件的处理

- (void)sliderValueChanged:(UISlider *)slider {
 
    CGFloat value = slider.value;
    
    //获取_sliderVie上的label
    UILabel *label = (UILabel *)[_sliderView viewWithTag:110];
    
    //重置label的文本内容,字体 和 画笔宽度
    label.text = [NSString stringWithFormat:@"线条宽度%.1f",value];
//    label.font = [UIFont systemFontOfSize:value];
    _drawView.width = value;
}


- (void)backButtonPress {

    _sliderView.hidden = YES;
}



- (void)subColorButtonPress:(UIButton *)button {
    
    _colorView.hidden = YES;
    
    //改变全局colorButton的显示颜色
    UIBarButtonItem *barButton = [_toolBar.items objectAtIndex:9];
    barButton.customView.backgroundColor = button.backgroundColor;
//    barButton.backgroundColor = button.backgroundColor;

    //设置button的背景颜色为画笔颜色
    _drawView.penColor = button.backgroundColor;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

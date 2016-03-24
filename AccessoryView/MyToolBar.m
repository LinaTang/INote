//
//  myToolBar.m
//  MyNote
//
//  Created by Ibokan on 16/1/15.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "MyToolBar.h"
#import "DrawViewController.h"
#import "UIImage+Scale.h"

/**
 设置两个toolbar
 一个作为控制器的toolBar
 另一个为键盘的附件栏
 - returns: toolBar
 */
@interface MyToolBar ()
{
    //使用全局变量可以在对象销毁时,销毁该对象的实例变量
    //使用的静态(static)变量可能会内存泄露
    
    NSArray *_fontsArr;         //字体样式

    NSArray *_fontSizes;        //字体大小

    UIView *_presentView;       //呈现pickerView的视图
    
    ColorView *_colorView;      //颜色版
}
@end

@implementation MyToolBar

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化toolBar
        //添加toolbar的Item
        UIBarButtonItem *drawItem = [[UIBarButtonItem alloc] initWithTitle:@"画图" style:UIBarButtonItemStylePlain target:self action:@selector(drawItemPress)];
        UIBarButtonItem *fontItem = [[UIBarButtonItem alloc] initWithTitle:@"字体" style:UIBarButtonItemStyleDone target:self action:@selector(fontItemPress)];
        UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(photoItemPress)];
        UIBarButtonItem *markItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(markItemPress)];
        
        //添加自适应分隔符
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //添加到自己的toolBar上面
        self.items =  @[ flexItem, drawItem, flexItem, fontItem, flexItem, photoItem, flexItem, markItem, flexItem ];
    }
    return self;
}



- (void)setTextView:(UITextView *)textView withViewController:(UIViewController<ColorChangeProtocol> *)viewController {
    
    _textView = textView;
    _viewController = viewController;
    
}


#pragma mark - drawItem的点击事件

- (void)drawItemPress {
    
    //放弃第一响应者的身份
    [_textView resignFirstResponder];
    
    DrawViewController *drawVC = [[DrawViewController alloc] init];
    
    //设置回调的函数,获得画图返回的图片
    drawVC.backBlock = ^(UIImage *backImg) {
        
        [self insertImageToTextView:backImg];
    };
    
    //模态视图
    [_viewController presentViewController:drawVC animated:NO completion:nil];
}


#pragma mark - fontitem点击事件及相关事件、代理方法的实现

- (void)fontItemPress {
    
    //取消文本框的第一响应者身份
    [_textView resignFirstResponder];
    
    _presentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 180, WIDTH, 180)];
    _presentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [_viewController.view addSubview:_presentView];
    
    //hide the toolBar
    self.hidden = YES;
    _textView.editable = NO;
    
    //1.添加确定按钮
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    okButton.frame = CGRectMake(WIDTH - 60, 5, 50, 20);
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_presentView addSubview:okButton];
    okButton.layer.cornerRadius = 3.5;
    okButton.layer.borderWidth = 0.2;
    okButton.backgroundColor = [UIColor lightGrayColor];
    okButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [okButton addTarget:self action:@selector(pickerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.添加取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(10, 5, 50, 20);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_presentView addSubview:cancelButton];
    cancelButton.backgroundColor = [UIColor lightGrayColor];
    cancelButton.layer.cornerRadius = 3.5;
    cancelButton.layer.borderWidth = 0.2;
    cancelButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [cancelButton addTarget:self action:@selector(pickerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.添加pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, WIDTH, 160)];
    [_presentView addSubview:pickerView];
    pickerView.tag = 100;

    //获取当前的文本框样式
//    NSDictionary *attributedDict = [_textView.attributedText attributesAtIndex:0 effectiveRange:nil];
//    UIFont *currentFont = [attributedDict valueForKey:NSFontAttributeName];
    

    //延时设置默认选择项(加载完数据在设置)
    [self performSelector:@selector(setDefaultSelectedItem:) withObject:pickerView afterDelay:0.34];


    //设置代理
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    //初始化字体样式和字号
    _fontsArr = [UIFont familyNames];
    _fontSizes = @[@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];

}

//设置默认选中item
- (void)setDefaultSelectedItem:(UIPickerView *)pickerView {
   
    UIFont *currentFont = [_textView.typingAttributes objectForKey:NSFontAttributeName];
    
    NSInteger fontSize =[_fontSizes indexOfObject:[NSString stringWithFormat:@"%.0f",currentFont.pointSize]];
    NSInteger fontType = [_fontsArr indexOfObject:currentFont.familyName];

    
    if (fontType != NSIntegerMax) {
        [pickerView selectRow:fontType inComponent:0 animated:YES];
    }
    
    if ( fontSize != NSIntegerMax ) {
        [pickerView selectRow:fontSize inComponent:1 animated:YES];
    }
    
}

#pragma mark -- 确定,取消按钮的方法

- (void)pickerButtonPress:(UIButton *)button {
    
    //如果是点击确定按钮
    if ([button.titleLabel.text isEqualToString:@"确定"]) {
        //获取pickerView
        UIPickerView *pickerView = [_presentView viewWithTag:100];
        
        NSString *selectedFontName = [_fontsArr objectAtIndex:[pickerView selectedRowInComponent:0]];
        NSString *selectedFontSize = [_fontSizes objectAtIndex:[pickerView selectedRowInComponent:1]];
        //设置字体样式 ----_textView.attributedText.string and _textView.text
        UIFont *font = [UIFont fontWithName:selectedFontName size:selectedFontSize.floatValue];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
        [mDict setObject:font forKey:NSFontAttributeName];
        //设置文本框输入的属性字符串的类型
        _textView.typingAttributes = [NSDictionary dictionaryWithDictionary:mDict];

         UIFont *font2 = [_textView.typingAttributes objectForKey:NSFontAttributeName];
        NSLog(@"fonts:%@",font2);
        
//        NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:_textView.attributedText.string attributes:@{ NSFontAttributeName : font }];
//        //改变当前的属性字符串
//        _textView.attributedText = attributedStr;
    }
    
    //从父视图中移除
    [_presentView removeFromSuperview];
    //显示回toolBar
    self.hidden = NO;
    _textView.editable = YES;
}



#pragma mark -- UIPickerViewDelegate的代理方法

//返回pickerView的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//返回pickerView的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return _fontsArr.count;
    }else {
        
        return _fontSizes.count;
    }
}

//返回pickerView上显示的内容,使用属性字符串(AttributedString)
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //create a label
    UILabel *labelView = [[UILabel alloc] init];
    //text alignment
    labelView.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        
        //create attributed string
        NSString *fontName = [_fontsArr objectAtIndex:row];
        NSDictionary *attributedDict = @{ NSFontAttributeName : [UIFont fontWithName:fontName size:18.0f] };
        NSAttributedString *titleFont = [[NSAttributedString alloc] initWithString:fontName attributes:attributedDict];

        //add attributed toa label's attributedText property
        labelView.attributedText = titleFont;
        
    }else {
        
        labelView.text = [_fontSizes objectAtIndex:row];
    }
    
    //return the label
    return labelView;
}

//设置coomponent的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return WIDTH * 3 / 5;
    }else {
        return WIDTH * 2 / 5;
    }
}


#pragma mark - photoItem的点击事件及相关代理方法的实现

- (void)photoItemPress {
    
    //如果在编辑状态则文本放弃第一响应者
    [_textView resignFirstResponder];
    
    UIImagePickerController *pickerCtrl = [UIImagePickerController new];
    pickerCtrl.view.frame = _viewController.view.frame;
    pickerCtrl.delegate = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *imgAction = [UIAlertAction actionWithTitle:@"PhotoLibrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [pickerCtrl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [_viewController.view addSubview:pickerCtrl.view];
        [_viewController presentViewController:pickerCtrl animated:YES completion:nil];
    }];
    UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"PhotosAlbum" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [pickerCtrl setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        [_viewController.view addSubview:pickerCtrl.view];
        [_viewController presentViewController:pickerCtrl animated:YES completion:nil];
    }];
    
    UIAlertAction * photoAction= [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [pickerCtrl setSourceType:UIImagePickerControllerSourceTypeCamera];

        [_viewController.view addSubview:pickerCtrl.view];
        [_viewController presentViewController:pickerCtrl animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"选项三");
    }];
    
    [alertController addAction:imgAction];
    [alertController addAction:libAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [_viewController presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark -- UIImagePickerControllerDelegate的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    /* --------键值
     //图库,相册
     UIImagePickerControllerOriginalImage,
     UIImagePickerControllerMediaType,
     UIImagePickerControllerReferenceURL
     //拍照
     UIImagePickerControllerOriginalImage,
     UIImagePickerControllerMediaType,
     UIImagePickerControllerMediaMetadata
     */

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self insertImageToTextView:image];
    
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - markItemPress的点击事件

- (void)markItemPress {
    
    if ( _colorView ) {
        //删除此view
        [_colorView removeFromSuperview];
        //指向空
        _colorView = nil;
    }else {
        //没有颜色板则创建一个新的
        
        //添加到ViewController中
        _colorView = [[ColorView alloc] init];
        [_viewController.view addSubview:_colorView];
        
        //否则view会按照以往的autoresizingMask计算
        _colorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //设置宽度约束条件
        [_viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

        //设置约束条件
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_colorView(60.0)]-0-[self]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_colorView, self )];
       
        //添加约束条件到父视图上
        [_viewController.view addConstraints:constraints];


        _colorView.backgroundColor = [UIColor clearColor];
        //设置代理人
        _colorView.delegate = _viewController;
    }

}


#pragma mark - 这里实现向textView中添加图片的操作
/**
 *  本类的私有方法
 *
 *  @param image 代传入的image
 */
- (void)insertImageToTextView:(UIImage *)image {
    
    //利用textField,textView的属性化文本,将图片以附件形式插入
    //创建附件
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    //transformToSize重置图片的大小,使其适应屏幕(大于屏幕宽度会被压缩)
    
    textAttachment.image = [image transformToFitSize];

    /////自定义ImageTextAttachment
    //    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    //    imageTextAttachment.image = image;
    
    //将附件转化为属性化属性文本
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    //获取选中的范围
    NSRange selectedRang = _textView.selectedRange;
    
    
    //-----------法一:获取textView的文本,转为可变属性文本-------------------//
//        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    //将附件属性文本插入到mutableStr中
//    [mutableStr insertAttributedString:textAttachmentString atIndex:selectedRang.location];
    //给textView的属性文本赋值
//        _textView.attributedText = mutableStr;
    
    
    //------------法二:直接插入到_textView中,上法一操作亦可-------------------//
    [_textView.textStorage insertAttributedString:textAttachmentString atIndex:selectedRang.location];
}


@end

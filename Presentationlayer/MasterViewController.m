//
//  ViewController.m
//  MyNotes
//
//  Created by tao_pc on 15-12-2.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "DelegateTransferProtocol.h"
#import "SearchResultTableViewController.h"
#import "NoteTableViewCell.h"
#import "BroadSideViewController.h"

@interface MasterViewController () <DelegateTransferProtocol,UISearchBarDelegate>
{
    //设置搜索代理控制器
    SearchResultTableViewController *_seaRTVC;
    //搜索控制器(须全局变量)
    UISearchController *_searchController;
    
    NSArray *_backgroudViews;
    UIImageView *_imageView;
    
    UILabel *_statusLabel;  //显示note的数量
}

//数据源
@property(nonatomic, strong)NSMutableArray *listArr;

@end


@implementation MasterViewController

#pragma mark - 重写listArr的set方法
- (void)setListArr:(NSMutableArray *)listArr {
    
    _listArr = listArr;
    
    //当listArr改变时，改变显示的note的数量（实现监听的效果）
    _statusLabel.text = [NSString stringWithFormat:@"%ld Notes",_listArr.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"备忘录";
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:225/255.0 blue:143/255.0 alpha:1];
    
//    self.clearsSelectionOnViewWillAppear = YES;
    
    //设置tableView的起始contentOffset(1-n即可将起始位置设置为第一个cell)
    self.tableView.contentOffset = CGPointMake(0, 1);
    //设置cell的分割线颜色
//    self.tableView.separatorColor = [UIColor lightGrayColor];
    //设置分割线的边距
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];

    _backgroudViews = @[@"1373531931517",@"13735319336",@"137353190294",@"1373531922949",@"1373531923248",@"1373531930482",@"1375426289875"];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    _imageView.image = [UIImage imageNamed:_backgroudViews[0]];
   
    self.tableView.backgroundView = _imageView;
    
    //左右的buttonItem
    UIImage *image = [UIImage imageNamed:@"user"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(personalButtonPress)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    ////初始化SearchResultTableViewController
    _seaRTVC = [SearchResultTableViewController new];
    _seaRTVC.deledate = self;
    
    //使用搜索控制器(ios8 and later)
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_seaRTVC];
    
    //设置代理
    _searchController.delegate = _seaRTVC;
    _searchController.searchResultsUpdater = _seaRTVC;
    _searchController.searchBar.delegate = self;
    
    //呈现searchController视图是是否dismiss当前Controller
    //_searchController.dimsBackgroundDuringPresentation = NO;
    // It is usually good to set the presentation context.
    //self.definesPresentationContext = YES;
    
    //设置searchBar样式
    //删除掉searchBar的外面视图
    for ( UIView *view in [_searchController.searchBar subviews] ) {
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    //自动调整大小
    [_searchController.searchBar sizeToFit];

    //添加表头的搜索栏
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    //注册重用单元格(暂不使用此方法,下面使用的不是默认cell类型)
//    [self.tableView registerClass:[NoteTableViewCell class] forCellReuseIdentifier:@"identifier"];
    
    //设置首页的toolBar
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _statusLabel.textColor = [UIColor blackColor];
    _statusLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *statusItem = [[UIBarButtonItem alloc] initWithCustomView:_statusLabel];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addButtonClick)];
    
    //自适应分隔符
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[flexItem, flexItem, statusItem, flexItem, addItem];
    
    ///////数据绑定
    _noteBL = [NoteBL new];
    self.listArr = [_noteBL findAll];
}

//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //显示toolBar
    self.navigationController.toolbarHidden = NO;

}

#pragma mark - 显示侧边栏的方法
- (void)personalButtonPress {
    
    static NSInteger flag = 1;
   
    if (flag == _backgroudViews.count){
        self.tableView.backgroundView = nil;
        flag = 0;
    }else {
        _imageView.image = [UIImage imageNamed:_backgroudViews[flag]];
        ++flag;
    }

    
//    BroadSideViewController *broadSideVC = [BroadSideViewController new];
//    [self addChildViewController:broadSideVC];
//    
//    broadSideVC.view.frame = CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height);
//    [self.view addSubview:broadSideVC.view];

//    self.view.bounds = CGRectMake(-100, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - 搜索框代理

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   
    //(重新)绑定数据
    _seaRTVC.originalData = _listArr;
}


#pragma mark - tableView相关代理方法的实现

//返回tableview的分区数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArr.count;
}

//返回tableview的cell数
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 55;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
  
    if (cell ==nil) {
        
        cell = [[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    }
    
    //取消选择时的灰色阴影效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    return cell;
}

//确认编辑状态相关方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //如果为删除选项
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //如果点击取消键,则取消tableView的编辑状态
            tableView.editing = NO;
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击确定则执行相应的删除操作
            Note *note = _listArr[indexPath.row];
            self.listArr = [[NoteBL new] remove:note];
            [self.tableView reloadData];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

//选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.note = _listArr[indexPath.row];
    detailVC.delegate = self;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//该方法在cell即将显示的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    //可以设置其他的条件
    
    //设置缩放动画效果
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0.6);      //缩放度的起始值
    scaleAnimation.toValue = @(1);          //缩放度的终值
    scaleAnimation.duration = 0.7;            //动画时间
    scaleAnimation.repeatCount = 1;         //动画的重复次数
    [cell.layer addAnimation:scaleAnimation forKey:@"qqqqq"];
    
    //设置透明度的变化
    CABasicAnimation *opacityAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation1.fromValue = @(0.0);
    opacityAnimation1.toValue = @(1);
    opacityAnimation1.duration = 1;
    opacityAnimation1.repeatCount = 0.7;
    [cell.layer addAnimation:opacityAnimation1 forKey:@"adasddsd"];
    
    
    NoteTableViewCell *myCell = (NoteTableViewCell *)cell;
    myCell.backgroundColor = [UIColor clearColor];
    
    myCell.note = _listArr[indexPath.row];
}


#pragma mark - navigationItem的点击事件

- (void)addButtonClick {
    
    AddViewController *addVC = [AddViewController new];
    addVC.delegate = self;

    //push过去
    [self.navigationController pushViewController:addVC animated:NO];
    
    //设置导航控制器的转场动画
    //1.创建一个CATransition对象
    CATransition *transition = [CATransition animation];
    
    //2.设置动画效果
    //设置动画样式--渐变(moveIn移动进来)
    [transition setType:kCATransitionFade];
    //设置动画时间
    transition.duration = 0.4;
    //设置动画方向
    [transition setSubtype:kCATransitionFromTop];
    
    //由我们指定转场动画
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}


#pragma mark - 实现代理协议的代理方法

- (void)getTheNewestListArray:(NSMutableArray *)newestArray {
   
    //把最新的数据给当前list
    self.listArr = newestArray;

    //重新加载tableView
    [self.tableView reloadData];
}


@end

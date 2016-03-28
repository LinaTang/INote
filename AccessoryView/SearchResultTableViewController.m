//
//  SearchResultTableViewController.m
//  MyNote
//
//  Created by ft on 15/12/17.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "Note.h"
#import "DetailViewController.h"

@interface SearchResultTableViewController ()<DelegateTransferProtocol>
{
    //存储搜索的结果
    NSMutableArray *_resultData;
}
@end

@implementation SearchResultTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化结果数组
        _resultData = [NSMutableArray new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置视图边缘起始位置
    self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];

    //关闭自动调整ScrollViewInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"resultCell"];
}

#pragma mark - TableView view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    
    Note *note = _resultData[indexPath.row];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    //需要转化属性字符串为普通字符串
    cell.textLabel.text = [note.attributedContent string];;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:note.date];

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//点击搜索行触发方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.note = _resultData[indexPath.row];
    detailVC.delegate = self;
    
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:detailVC];
    detailVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(leftButtonClick)];

    [self presentViewController:nVC animated:YES completion:nil];
}

- (void)leftButtonClick {
    
    //放弃模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 搜索控制器发生搜索是执行的代理方法
//required
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //此处和viewDidLoad中automaticallyAdjustsScrollViewInsets对应,需设置tableView的Frame值
    self.tableView.frame = CGRectMake(0, 64, 320, 568);
    
    //清空结果数组
    [_resultData removeAllObjects];
    
    NSString *searchText = searchController.searchBar.text;
    
    //从原始数据中筛选符合的数据加入到结果中
    for (Note *aNote in self.originalData) {
        //注意转化为普通字符串
        if ( [[aNote.attributedContent string] containsString:searchText] ) {
            [_resultData addObject:aNote];
        }
    }
    
    //未搜索到数据
    if (_resultData.count == 0) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, 320, 44);
        label.text = @"未搜索到数据";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = label;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
//    NSLog(@"%@",NSStringFromCGRect(self.tableView.tableHeaderView.frame));
    
    //重新加载表视图
    [self.tableView reloadData];
}

#pragma mark - 实现协议的方法
- (void)getTheNewestListArray:(NSMutableArray *)newestArray {
    self.originalData = newestArray;
    
    //如果代理人实现了这个方法,则执行该方法
    if ([_deledate respondsToSelector:@selector(getTheNewestListArray:)]) {
        [_deledate getTheNewestListArray:newestArray];
    }
}



@end

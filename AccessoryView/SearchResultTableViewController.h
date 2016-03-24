//
//  SearchResultTableViewController.h
//  MyNote
//
//  Created by Ibokan on 15/12/17.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateTransferProtocol.h"

/////用于显示搜索结果
/////兼任搜索控制器,搜索框的代理人
@interface SearchResultTableViewController : UITableViewController <UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>


//原始数据,弱引用
@property(nonatomic,weak)NSArray *originalData;

//添加代理人,用于反向传值
@property(nonatomic,assign)id<DelegateTransferProtocol>  deledate;


@end

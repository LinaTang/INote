//
//  DelegateTransferProtocol.h
//  MyNote
//
//  Created by ft on 15/12/15.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DelegateTransferProtocol <NSObject>

@optional

- (void)getTheNewestListArray:(NSMutableArray *)newestArray;

//重新加载数据
- (void)reloadDataList;

@end

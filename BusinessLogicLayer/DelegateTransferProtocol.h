//
//  DelegateTransferProtocol.h
//  MyNote
//
//  Created by Ibokan on 15/12/15.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DelegateTransferProtocol <NSObject>

@optional

- (void)getTheNewestListArray:(NSMutableArray *)newestArray;

//重新加载数据
- (void)reloadDataList;

@end

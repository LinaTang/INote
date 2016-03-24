//
//  AddViewController.h
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateTransferProtocol.h"


/**
 *  添加note的视图控制器
 */
@interface AddViewController : UIViewController


@property(nonatomic,assign)id<DelegateTransferProtocol> delegate;


@end

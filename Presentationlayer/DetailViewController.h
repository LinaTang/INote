//
//  DetailViewController.h
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "DelegateTransferProtocol.h"

//note详情界面的控制器
@interface DetailViewController : UIViewController


@property(nonatomic,strong)Note *note;

@property(nonatomic,assign)id<DelegateTransferProtocol> delegate;

@end

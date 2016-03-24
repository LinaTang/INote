//
//  ViewController.h
//  MyNotes
//
//  Created by tao_pc on 15-12-2.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBL.h"
#import "NoteDAO.h"
#import "Note.h"

/////表示层内容
//主界面控制器
@interface MasterViewController : UITableViewController

@property(nonatomic,strong)NoteBL *noteBL;
//@property(nonatomic,strong)NoteDAO *noteDAO;

@end


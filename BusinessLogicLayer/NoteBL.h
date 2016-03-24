//
//  NoteBL.h
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteDAO.h"

@class Note;

/////业务逻辑层的方法
@interface NoteBL : NSObject

@property(nonatomic,strong)NSMutableArray *notesList;

//插入备忘录的方法
- (NSMutableArray *)createNote:(Note *)model;

//删除备忘录的方法
- (NSMutableArray *)remove:(Note *)model;

//修改备忘录方法
- (NSMutableArray *)modify:(Note *)model;

//查询所有数据的方法
- (NSMutableArray *)findAll;

@end

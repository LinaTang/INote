//
//  NoteBL.m
//  MyNotes
//
//  Created by tao_pc on 15-12-3.
//  Copyright (c) 2015年 tao_pc. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL

-(NSMutableArray *)createNote:(Note *)model {
    NoteDAO *dao = [NoteDAO new];
    [dao create:model];
    
    return [dao findAll];
}

- (NSMutableArray *)modify:(Note *)model {
    
    NoteDAO *dao = [NoteDAO new];
    
    [dao modify:model];
    
    return [dao findAll];
}

- (NSMutableArray *)remove:(Note *)model {
    NoteDAO *dao = [NoteDAO new];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray *)findAll {
    NoteDAO *dao = [NoteDAO new];
    //业务逻辑层中第一次调用,如果没有数据创建文件,并且硬编码两条数据
    [dao createEditableCopyOfDatabaseIfNeeded];
    
    return [dao findAll];
}

@end

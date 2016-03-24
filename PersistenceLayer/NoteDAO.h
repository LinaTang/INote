//
//  NoteDAO.h
//  MyNote
//
//  Created by Ibokan on 15/12/11.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

/////数据持久层
@interface NoteDAO : NSObject

@property(nonatomic,strong)NSMutableArray *listData;


//如果需要(没有)创建一个可编辑的数据
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入备忘录的方法
- (int)create:(Note *)model;

//删除备忘录方法
- (int)remove:(Note *)model;

//修改备忘录方法
- (int)modify:(Note *)model;

//查询所有数据的方法
- (NSMutableArray *)findAll;

//按照主键查询数据的方法
- (Note *)findbyId:(Note *)model;



@end

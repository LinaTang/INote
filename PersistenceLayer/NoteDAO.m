//
//  NoteDAO.m
//  MyNote
//
//  Created by Ibokan on 15/12/11.
//  Copyright © 2015年 ft. All rights reserved.
//

#import "NoteDAO.h"

#define ARCHIVE_KEY @"archiveKey"


@implementation NoteDAO

- (int)create:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
//    [array addObject:model];
    [array insertObject:model atIndex:0];
    
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
    //archiver(存档)对象的encodeObject;方法可以通过键对实现NSCoding协议的对象进行归档
    [archiver encodeObject:array forKey:ARCHIVE_KEY];
    
    //archiver.finishEncoding发出归档完成消息
    [archiver finishEncoding];
    //将NSData对象写入到文件中
    [theData writeToFile:path atomically:YES];
    
    return 0;
}

- (int)remove:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
    
    for (Note *note in array) {
        //比较日期主键是否相等
        if ([note.date isEqualToDate:model.date]) {
            [array removeObject:note];
            
            NSMutableData *theData = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
            [archiver encodeObject:array forKey:ARCHIVE_KEY];
            [archiver finishEncoding];
            [theData writeToFile:path atomically:YES];
            
            break;
        }
    }
    return 0;
}

- (int)modify:(Note *)model {
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
    
    for ( Note *note in array) {
        //比较日期主键是否相等
        if ([note.date isEqualToDate:model.date]) {

            note.attributedContent = model.attributedContent;
            note.dict = model.dict;
            //depracated
            //note.content = model.content;
            
            NSMutableData *theData = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
            [archiver encodeObject:array forKey:ARCHIVE_KEY];
            [archiver finishEncoding];
            
            [theData writeToFile:path atomically:YES];
            
            break;
        }
    }
    return 0;
}


- (NSMutableArray *)findAll {
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSData *theData = [NSData dataWithContentsOfFile:path];
    
    if ( [theData length] > 0 ) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
        listData = [unArchiver decodeObjectForKey:ARCHIVE_KEY];
        [unArchiver finishDecoding];
    }

    return listData;
}

- (Note *)findbyId:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSData *theData = [NSData dataWithContentsOfFile:path];
    
    if ( [theData length] > 0 ) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
        listData = [unArchiver decodeObjectForKey:ARCHIVE_KEY];
        [unArchiver finishDecoding];
        
        for (Note *noet in listData) {
            //比较日期主键是否相等
            if ([noet.date isEqualToDate:model.date]) {
                return noet;
            }
        }
    }
    return nil;
}


//该方法用于获取放置在沙箱Documents目录下面的文件的完整路径
- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"notes"];
    //    [self getTheCurrentDate];
    return path;
}


//判断在沙箱目录下是否存在归档文件Notes.plist,如果不存在则创建一个,并且硬编码两条初始化数据
- (void)createEditableCopyOfDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    BOOL dbExits = [fileManager fileExistsAtPath:writableDBPath];
   //判断归档文件是否存在
    if (!dbExits) {
        NSString *path = [self applicationDocumentsDirectoryFile];

        //添加一些测试用例
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date1 = [dateFormatter dateFromString:@"2014-12-11 20:22:56"];
        Note *note1 = [[Note alloc] init];
        note1.date = date1;
        note1.content = @"Welcome to MyNote";
        
        NSDate *date2 = [dateFormatter dateFromString:@"2015-12-11 20:24:45"];
        Note *note2 = [[Note alloc] init];
        note2.date =date2;
        note2.content = @"欢迎使用MyNote";
    
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [array addObject:note1];
        [array addObject:note2];
        
        NSMutableData *theData = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
        
        [archiver encodeObject:array forKey:ARCHIVE_KEY];
        [archiver finishEncoding];
        
        [theData writeToFile:path atomically:YES];
    }
}


@end

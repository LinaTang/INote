//
//  SingletonNotesList.m
//  MyNote
//
//  Created by ft on 15/12/22.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import "SingletonNotesList.h"
#import "NoteBL.h"

//定义静态全局变量
static SingletonNotesList *notesList = nil;

@implementation SingletonNotesList

#pragma mark - 以下是默认在ARC环境下的单例方法

//获取静态全局对象
+(SingletonNotesList *)getNotesList {
    
    //如果没有生成对象,则为静态全局变量分配内存
    if (notesList == nil) {
        //初始化notesList
        NoteBL *noteBL = [NoteBL new];
        notesList = [SingletonNotesList arrayWithArray:[noteBL findAll]];
    }
    
    return notesList;
}

//防止通过alloc或者new来创建新的对象,重写allocWithZone
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (notesList == nil) {
        notesList = [[super allocWithZone:zone] init];
    }
    
    return notesList;
}

#pragma mark - 重写copyWithZone:和mutableCopyWithZone;方法
//防止通过copy创建新的实例
- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

//防止通过mutableCopy创建新的实例
- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return self;
}


///MRC环境下添加


@end

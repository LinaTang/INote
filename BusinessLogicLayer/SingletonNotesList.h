//
//  SingletonNotesList.h
//  MyNote
//
//  Created by ft on 15/12/22.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import <Foundation/Foundation.h>

//可变数组不可以继承(类簇)
@interface SingletonNotesList : NSMutableArray

+ (SingletonNotesList *)getNotesList;

@end

//
//  SingletonNotesList.h
//  MyNote
//
//  Created by Ibokan on 15/12/22.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

//可变数组不可以继承(类簇)
@interface SingletonNotesList : NSMutableArray

+ (SingletonNotesList *)getNotesList;

@end

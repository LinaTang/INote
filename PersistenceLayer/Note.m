//
//  Note.m
//  MyNote
//
//  Created by ft on 15/12/11.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import "Note.h"

@implementation Note

#pragma mark - 实现NSCoding的协议方法

//编码方法（对OC对象进行编码操作）
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"date"];
//    [aCoder encodeObject:_content forKey:@"content"];                       //***
    [aCoder encodeObject:_attributedContent forKey:@"attributedContent"];
    [aCoder encodeObject:_dict forKey:@"dictionary"];
}

//反编码方法（对OC对象惊醒解码操作）
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.date = [aDecoder decodeObjectForKey:@"date"];
//    self.content = [aDecoder decodeObjectForKey:@"content"];                       //***
    self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
    self.dict = [aDecoder decodeObjectForKey:@"dictionary"];
    
    return self;
}

+ (Note *)noteWithDate:(NSDate *)date content:(NSString *)content{                       //***

    Note *note = [[Note alloc] init];
    note.date = date;
    note.content = content;

    return note;
}

+ (Note *)noteWithDate:(NSDate *)date attributedContent:(NSAttributedString *)attContent andInfomation:(NSDictionary *)dict {
    
    Note *note = [[Note alloc] init];
    note.date = date;
    note.attributedContent = attContent;
    note.dict = dict;
    
    return note;
}


@end

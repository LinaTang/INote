//
//  Note.h
//  MyNote
//
//  Created by ft on 15/12/11.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import <Foundation/Foundation.h>

///封装每条备忘录为一个对象(该对象实现了NSCoding的协议)
@interface Note : NSObject <NSCoding>

//主键:日期
@property(nonatomic,strong)NSDate *date;

//属性文本(记录备忘录内容,包括图片信息)
@property(nonatomic,strong)NSAttributedString *attributedContent;

//备忘录相关属性信息(分组,背景颜色"color",最后修改时间"lastModify")
@property(nonatomic,strong)NSDictionary *dict;



#pragma mark *** Deprecated/discouraged APIs *** 

//备忘录内容(弃用,改为下面的attributedContent属性)Deprecated
@property(nonatomic,strong)NSString *content;

//备忘录的便利构造器
+ (Note *)noteWithDate:(NSDate *)date content:(NSString *)content;


//备忘录的便利构造器(新方法)
+ (Note *)noteWithDate:(NSDate *)date attributedContent:(NSAttributedString *)attContent andInfomation:(NSDictionary *)dict;



@end

//
//  NoteUser.h
//  INote
//
//  Created by FT on 16/4/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteUser : NSObject


@property(nonatomic, strong)NSString *name;

@property(nonatomic, strong)NSString *password;


+ (instancetype)sharedUser;

+ (void)logout;

@end

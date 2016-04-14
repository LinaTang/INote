//
//  NoteUser.m
//  INote
//
//  Created by FT on 16/4/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "NoteUser.h"

static NoteUser *_user = nil;

@implementation NoteUser


+ (instancetype)sharedUser {
    
    if (_user) {
        _user = [[NoteUser alloc] init];
    }
    
    return _user;
}

+ (void)logout {
    
    _user = nil;
}

@end

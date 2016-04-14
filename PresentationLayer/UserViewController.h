//
//  UserViewController.h
//  INote
//
//  Created by FT on 16/4/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserChangeProtocol <NSObject>

@required
- (void)userHasChanged;

@end

@interface UserViewController : UIViewController

//设置代理人
@property(nonatomic, weak)id<UserChangeProtocol> delegate;


@end

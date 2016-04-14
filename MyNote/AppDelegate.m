//
//  AppDelegate.m
//  MyNote
//
//  Created by ft on 15/12/3.
//  Copyright © 2015年 fft1026@163.com All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "NoteUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MasterViewController *masterVC = [MasterViewController new];
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:masterVC];
    
    self.window.rootViewController = navCtr;
    
    /*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //判断是否首次启动
    if ([userDefaults boolForKey:@"firstLaunch"]) {

        NSDictionary *usersDict = [userDefaults objectForKey:@"usersDict"];
        for (NSDictionary *dict in usersDict) {
            if ([[dict objectForKey:@"login"] boolValue]) {
                NoteUser *user = [NoteUser sharedUser];
                user.name = [dict objectForKey:@"name"];
                user.password = [dict objectForKey:@"pwd"];
                
                break;
            }
        }
    }else {
        //首次启动
        [userDefaults setBool:YES forKey:@"firstLaunch"];
        
        NSDictionary *user1 = @{@"name":@"Zeaa", @"pwd":@"123", @"login":@YES};
        NSDictionary *user2 = @{@"name":@"Jone", @"pwd":@"123", @"login":@NO};
        
        NSDictionary *usersDict = [NSDictionary dictionaryWithObjects:@[user1,user2] forKeys:@[@"user1",@"user2"]];
        
        [userDefaults setObject:usersDict forKey:@"usersDict"];
    }
    */
    
    
    return YES;
}

//取消横屏的方法------亦可以在plist文件中修改(Supported interface orientations)下的其它选项删除
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    //返回竖屏的
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

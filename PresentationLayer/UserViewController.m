//
//  UserViewController.m
//  INote
//
//  Created by FT on 16/4/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "UserViewController.h"
#import "NoteUser.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:225/255.0 blue:143/255.0 alpha:1];
    
    
    
    
    //读取登录信息(未登录，已登录用户)
    NoteUser *user = [NoteUser sharedUser];
    
    if (user) {
        NSLog(@"%@,%@",user.name,user.password);
    }else {
        
        NSLog(@"未登录");
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 160, 100, 40)];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(50, 220, 100, 40)];
    [button3 setTitle:@"退出" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
}


- (void)buttonClick {
    
    [NoteUser logout];
    
    if (self.delegate) {
        [self.delegate userHasChanged];
    }
}


- (void)button2Click {
    
    if (self.delegate) {
        [self.delegate userHasChanged];
    }
}


- (void)button3Click {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

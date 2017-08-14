//
//  AppDelegate+ViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/9.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  

#import "AppDelegate+ViewController.h"
#import "RootTabBarController.h"
@implementation AppDelegate (ViewController)

- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.window makeKeyAndVisible];
    
}

- (void)setRootViewController
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = [[RootTabBarController alloc] init];
    
}
@end

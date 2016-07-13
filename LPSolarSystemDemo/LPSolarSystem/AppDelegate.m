//
//  AppDelegate.m
//  LPSolarSystem
//
//  Created by XuYafei on 15/12/26.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen  mainScreen].bounds];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [_window makeKeyAndVisible];
    return YES;
}

@end

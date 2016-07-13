//
//  LPPushDataManager.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushDataManager.h"

static NSString *key = @"key";

@implementation LPPushDataManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSArray *)getCacheData {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        array = [NSArray array];
    }
    NSLog(@"getCacheData:%@ withKey:%@", array ,key);
    return array;
}

+ (void)setCacheData:(NSArray *)array {
    if (!array) {
        array = [NSArray array];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"setCacheData:%@ withKey:%@", array, key);
}

+ (void)addNotification:(NSDictionary *)dictionary {
    NSMutableArray *array = [[LPPushDataManager getCacheData] mutableCopy];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:dictionary];
    [LPPushDataManager setCacheData:array];
    NSLog(@"addNotification:%@ withKey:%@", dictionary, key);
}

@end

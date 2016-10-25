//
//  XFUserDefaults.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFUserDefaults.h"

@implementation XFUserDefaults

+ (NSArray *)getCacheDataWithKey:(NSString *)key {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        array = [NSArray array];
    }
    return array;
}

+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key {
    if (!array) {
        array = [NSArray array];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addCacheData:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSMutableArray *array = [[XFUserDefaults getCacheDataWithKey:key] mutableCopy];
    [array addObject:dictionary];
    [XFUserDefaults setCacheData:array withKey:key];
}

+ (void)removeCacheData:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSMutableArray *array = [[XFUserDefaults getCacheDataWithKey:key] mutableCopy];
    [array removeObject:dictionary];
    [XFUserDefaults setCacheData:array withKey:key];
}

+ (void)removeCacheDataAtIndex:(NSInteger)index withKey:(NSString *)key {
    NSMutableArray *array = [[XFUserDefaults getCacheDataWithKey:key] mutableCopy];
    [array removeObjectAtIndex:index];
    [XFUserDefaults setCacheData:array withKey:key];
}

@end

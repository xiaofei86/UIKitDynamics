//
//  XFUserDefaults.h
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XFUserDefaults : NSObject

+ (NSArray *)getCacheDataWithKey:(NSString *)key;
+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key;

+ (void)addCacheData:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (void)removeCacheData:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (void)removeCacheDataAtIndex:(NSInteger)index withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

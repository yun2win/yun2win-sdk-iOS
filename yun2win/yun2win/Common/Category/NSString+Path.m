//
//  NSString+Path.m
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSString+Path.h"
#import "Y2WUsers.h"
@implementation NSString (Path)

#pragma mark - Base

+ (NSString *)pathOfDocument {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)pathOfCache {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)pathOfTemp {
    return NSTemporaryDirectory();
}



#pragma mark - value-path key

+ (NSString *)cachePathForKey:(NSString *)key {
    return [[self pathOfCache] stringByAppendingPathComponent:key];
}

+ (NSString *)tempPathForKey:(NSString *)key {
    return [[self pathOfTemp] stringByAppendingPathComponent:key];
}




#pragma mark - yun2win

+ (NSString *)realmPathForUID:(NSString *)uid {
    NSString *documentPath = [self pathOfDocument];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:@"db"];
    NSString *userPath     = [dataBasePath stringByAppendingPathComponent:uid];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [userPath stringByAppendingPathComponent:@"realm"];
}

+ (NSString *)webAppDataPathForUID:(NSString *)uid name:(NSString *)name {
    NSString *documentPath = [self pathOfDocument];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:@"webAppData"];
    NSString *userPath     = [dataBasePath stringByAppendingPathComponent:uid];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [userPath stringByAppendingPathComponent:name];
}

+ (NSString *)attachmentPathForID:(NSString *)ID name:(NSString *)name {
    NSString *cachePath = [self pathOfCache];
//    NSString *attachmentPath = [cachePath stringByAppendingPathComponent:@"attachment"];
    NSString *path = [cachePath stringByAppendingPathComponent:ID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [path stringByAppendingPathComponent:name];
}



#pragma mark -

+ (NSString *)emojiPath {
    NSString *path = [[self pathOfDocument] stringByAppendingPathComponent:@"emoji"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return path;
}

+ (NSString *)getDocumentPath:(NSString *)fileName Type:(NSString *)type
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *createPath = [[self pathOfDocument] stringByAppendingFormat:@"/%@/%@",[Y2WUsers getInstance].getCurrentUser.ID,type];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [createPath stringByAppendingFormat:@"/%@",fileName];
}




#pragma mark - Helper

- (BOOL)isPathExsit {
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (unsigned long long)fileSize {
    if (![self isPathExsit]) {
        return 0;
    }
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
    NSNumber *number = [dict objectForKey:NSFileSize];
    return [number unsignedLongLongValue];
}

@end

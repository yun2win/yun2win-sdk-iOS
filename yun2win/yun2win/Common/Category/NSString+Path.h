//
//  NSString+Path.h
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

#pragma mark - value-path key

//+ (NSString *)cachePathForKey:(NSString *)key;

+ (NSString *)tempPathForKey:(NSString *)key;


#pragma mark - yun2win

+ (NSString *)realmPathForUID:(NSString *)uid;

+ (NSString *)webAppDataPathForUID:(NSString *)uid name:(NSString *)name;

+ (NSString *)attachmentPathForID:(NSString *)ID name:(NSString *)name;

+ (NSString *)getDocumentPath:(NSString *)fileName Type:(NSString *)type;

+ (NSString *)emojiPath;



#pragma mark - Helper

- (BOOL)isPathExsit;

- (unsigned long long)fileSize;

@end

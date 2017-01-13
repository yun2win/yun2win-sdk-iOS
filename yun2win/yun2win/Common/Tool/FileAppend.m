//
//  FileAppend.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "FileAppend.h"

@implementation FileAppend

- (id)initWithFilePath:(NSString *)path name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    self = [super init];
    if (self) {
        self.path = path;
        self.name = name;
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

+ (id)fileAppendWithFilePath:(NSString *)path name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    return [[FileAppend alloc] initWithFilePath:path name:name fileName:fileName mimeType:mimeType];
}

@end

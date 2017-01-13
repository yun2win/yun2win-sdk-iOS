//
//  FileAppend.h
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileAppend : NSObject


@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *mimeType;

+ (id)fileAppendWithFilePath:(NSString *)path name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end

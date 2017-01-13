//
//  NSDictionary+Json.h
//  API
//
//  Created by QS on 16/3/17.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

- (NSString *)toJsonString;

- (NSString *)toJsonStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error;

@end


@interface NSString (Json)

- (id)parseJsonString;

@end

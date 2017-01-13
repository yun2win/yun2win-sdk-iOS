//
//  HttpRequest.h
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "FileAppend.h"

typedef void (^ProgressBlock) (CGFloat fractionCompleted);

@interface HttpRequest : NSObject

+ (void)POSTWithURL:(NSString *)url
            headers:(NSDictionary *)headers
         parameters:(NSDictionary *)parameters
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;


+ (void)GRTWithURL:(NSString *)url
           headers:(NSDictionary *)headers
        parameters:(NSDictionary *)parameters
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)GETWithURL:(NSString *)url timeStamp:(NSString *)timeStamp parameters:(NSDictionary *)parameter success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)POSTNoHeaderWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)PUTWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)DELETEWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (NSURLSessionUploadTask *)UPLOADWithURL:(NSString *)url
                                     path:(NSString *)path
                                  headers:(NSDictionary *)headers
                                 progress:(ProgressBlock)progress
                                  success:(void (^)(NSDictionary *data))success
                                  failure:(void (^)(NSError *error))failure;

+ (NSURLSessionDownloadTask *)DOWNLOADWithURL:(NSString *)url
                                         path:(NSString *)path
                                      headers:(NSDictionary *)headers
                                     progress:(ProgressBlock)progress
                                      success:(void (^)(NSURL *url))success
                                      failure:(void (^)(NSError *error))failure;









+ (void)UPLOADWithURL:(NSString *)url
           parameters:(NSDictionary *)parameter
          fileAppend:(FileAppend *)fileAppend
              progress:(ProgressBlock)progress
              success:(void(^)(id data))success
              failure:(void(^)(NSError *error))failure;

+ (void)DOWNLOADWithURL:(NSString *)url
        PathDirectory:(NSSearchPathDirectory)pathDirectory
             parameters:(NSDictionary *)parameter
               progress:(ProgressBlock)progress
                success:(void(^)(NSURL *path))success
                failure:(void(^)(NSError *error))failure;



+ (void)DOWNLOADWithURL:(NSString *)url
             parameters:(NSDictionary *)parameter
               progress:(ProgressBlock)progress
                success:(void(^)(NSURL *path))success
                failure:(void(^)(NSError *error))failure;
@end

@interface HttpRequest (Category)
+ (id)cleanNullWithResponseObject:(id)responseObject;
@end

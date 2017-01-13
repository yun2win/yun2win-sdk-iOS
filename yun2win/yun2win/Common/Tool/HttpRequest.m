//
//  HttpRequest.m
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#define TOKEN  [Y2WUsers getInstance].getCurrentUser.token

#import "HttpRequest.h"

@implementation HttpRequest

+ (void)POSTWithURL:(NSString *)url
            headers:(NSDictionary *)headers
         parameters:(NSDictionary *)parameters
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    for (NSString *key in headers) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    [manager operationQueue];
}


+ (void)GRTWithURL:(NSString *)url
            headers:(NSDictionary *)headers
         parameters:(NSDictionary *)parameters
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString *key in headers) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    
    [manager operationQueue];
}





+(void)GETWithURL:(NSString *)url
       parameters:(NSDictionary *)parameter
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}

+ (void)GETWithURL:(NSString *)url
         timeStamp:(NSString *)timeStamp
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"Client-Sync-Time"];
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}

+(void)POSTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;

        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}

+(void)POSTNoHeaderWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}

+ (void)PUTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        NSLog(@"%s---%@",__FUNCTION__, error);

        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}

+(void)DELETEWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote sync:^(NSError *error) {
                    if (error) {
                        if (failure) failure(error);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}



+ (NSURLSessionDataTask *)UPLOADWithURL:(NSString *)url
                                     path:(NSString *)path
                                  headers:(NSDictionary *)headers
                                 progress:(ProgressBlock)progress
                                  success:(void (^)(NSDictionary *))success
                                  failure:(void (^)(NSError *))failure {

    if (![path isPathExsit]) {
        if (failure) {
            failure([NSError errorWithDomain:@"UPLOAD" code:1 userInfo:@{@"message": @"路径不存在"}]);
        }
        return nil;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    for (NSString *key in headers) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"multipart/form-data", @"application/json", nil];
    
    return [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:path.lastPathComponent error:&error];
        if (error && failure) {
            failure(error);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(uploadProgress.fractionCompleted);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([self cleanNullWithResponseObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (NSURLSessionDownloadTask *)DOWNLOADWithURL:(NSString *)url
                                         path:(NSString *)path
                                      headers:(NSDictionary *)headers
                                     progress:(ProgressBlock)progress
                                      success:(void (^)(NSURL *))success
                                      failure:(void (^)(NSError *))failure {

    
    unsigned long long downloadedBytes = [path fileSize];
    if (downloadedBytes > 0) {
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
        [headers setValue:requestRange forKey:@"Range"];
        NSLog(@"已下载大小: %@", @(downloadedBytes));
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    for (NSString *key in headers) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (!progress) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress.fractionCompleted);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        if (success) {
            success(filePath);

        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}



+ (void)UPLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter fileAppend:(FileAppend *)fileAppend progress:(ProgressBlock)progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[NSString MD5HashOfFile:fileAppend.path] forHTTPHeaderField:@"Content-MD5"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded",@"application/json", @"multipart/form-data", @"text/plain",@"text/html", nil];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:fileAppend.path]
                                    name:fileAppend.name
                                fileName:fileAppend.fileName
                                mimeType:fileAppend.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)DOWNLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter progress:(ProgressBlock)progress success:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure
{
    [self DOWNLOADWithURL:url PathDirectory:NSDocumentDirectory parameters:parameter progress:progress success:success failure:failure];
}

+ (void)DOWNLOADWithURL:(NSString *)url
          PathDirectory:(NSSearchPathDirectory)pathDirectory
             parameters:(NSDictionary *)parameter
               progress:(ProgressBlock)progress
                success:(void (^)(NSURL *))success
                failure:(void (^)(NSError *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
//        return [NSURL URLWithString: [path stringByAppendingPathComponent:[response suggestedFilename]]];
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:pathDirectory inDomain:NSAllDomainsMask appropriateForURL:nil create:NO error:nil];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            success(filePath);
        }
        else{
            failure(error);
        }
    }];
    
    [downloadTask resume];
}

@end







@implementation HttpRequest (Category)

+ (id)cleanNullWithResponseObject:(id)responseObject
{
    if (!responseObject) {
        return nil;
        
    }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return [self cleanNullWithDictionary:responseObject];
        
    }else if ([responseObject isKindOfClass:[NSArray class]]) {
        return [self cleanNullWithArray:responseObject];
        
    }else {
        return [NSString stringWithFormat:@"%@",responseObject];
    }
}

+ (NSDictionary *)cleanNullWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *dict = [dic mutableCopy];
    for (NSString *key in [dict allKeys]) {
        if ([dict[key] isKindOfClass:[NSNull class]]) {
            dict[key] = @"";
            
        }else if ([dict[key] isKindOfClass:[NSDictionary class]]){
            dict[key] = [self cleanNullWithDictionary:dict[key]];
            
        }else if ([dict[key] isKindOfClass:[NSArray class]]){
            dict[key] = [self cleanNullWithArray:dict[key]];
        }
    }
    return dict;
}
+ (NSArray *)cleanNullWithArray:(NSArray *)arr
{
    NSMutableArray *array = [arr mutableCopy];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isKindOfClass:[NSNull class]]) {
            array[i] = @"";
            
        }else if ([array[i] isKindOfClass:[NSArray class]]) {
            array[i] = [self cleanNullWithArray:array[i]];
            
        }else if ([array[i] isKindOfClass:[NSDictionary class]]) {
            array[i] = [self cleanNullWithDictionary:array[i]];
        }
    }
    return array;
}

@end

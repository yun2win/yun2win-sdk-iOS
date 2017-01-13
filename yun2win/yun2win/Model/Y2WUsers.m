//
//  Y2WUsers.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WUsers.h"
#import "CurrentUserBase.h"

@interface Y2WUsers ()

@property (nonatomic, retain, readwrite) Y2WUsersRemote *remote;

@property (nonatomic, retain) NSCache *cache;

@end

@implementation Y2WUsers

+ (instancetype)getInstance {
    
    static dispatch_once_t once;
    static Y2WUsers *users;
    dispatch_once(&once, ^{
        users = [[Y2WUsers alloc]init];
        users.cache = [[NSCache alloc] init];
        users.remote = [[Y2WUsersRemote alloc] initWithUsers:users];
    });
    return users;
}

- (Y2WCurrentUser *)getCurrentUser {
    return self.currentUser;
}



- (Y2WUser *)addOrUpdateUserWithBase:(UserBase *)base {
    if (!base) {
        return nil;
    }
    Y2WUser *user = [self.cache objectForKey:base.ID];
    if (user) {
        [user updateWithBase:base];
    
    }else {
        user = [[Y2WUser alloc] initWithBase:base];
        [self.cache setObject:user forKey:base.ID];
    }
    return user;
}

- (Y2WUser *)getUserById:(NSString *)userId {
    Y2WUser *user = [self.cache objectForKey:userId];
    if (user) {
        return user;
    }
    if ([userId isEqualToString:self.currentUser.ID]) {
        return self.currentUser;
    }
    UserBase *base = [UserBase objectForPrimaryKey:userId];
    return [self addOrUpdateUserWithBase:base];
}


- (void)getUserById:(NSString *)userId success:(void (^)(Y2WUser *))success failure:(void (^)(NSError *))failure {
    Y2WUser *user = [self getUserById:userId];
    if (user) {
        if (success) {
            success(user);
        }
        return;
    }
    [self.remote getUserById:userId success:success failure:failure];
}






// 使用联系人和成员构造一个占位用户

- (Y2WUser *)getUserWithContact:(Y2WContact *)contact {
    if (!contact.userId) {
        return nil;
    }
    Y2WUser *user = [[Y2WUsers getInstance] getUserById:contact.userId];
    if (!user) {
        [self createOrUpdateUserWithID:contact.userId name:contact.name avatarUrl:contact.avatarUrl];
        user = [[Y2WUsers getInstance] getUserById:contact.userId];
    }
    return user;
}

- (Y2WUser *)getUserWithSessionMember:(Y2WSessionMember *)member {
    if (!member.userId) {
        return nil;
    }
    Y2WUser *user = [[Y2WUsers getInstance] getUserById:member.userId];
    if (!user) {
        [self createOrUpdateUserWithID:member.userId name:member.name avatarUrl:member.avatarUrl];
        user = [[Y2WUsers getInstance] getUserById:member.userId];
    }
    return user;
}

- (void)createOrUpdateUserWithID:(NSString *)uid name:(NSString *)name avatarUrl:(NSString *)avatarUrl {
    if (!uid) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = uid;
    dict[@"name"] = name;
    dict[@"avatarUrl"] = avatarUrl;
    dict[@"email"] = @"";
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [UserBase createOrUpdateInDefaultRealmWithValue:dict];
    }];
}

@end







@interface Y2WUsersRemote ()

@property (nonatomic, weak) Y2WUsers *users;

@end

@implementation Y2WUsersRemote

- (instancetype)initWithUsers:(Y2WUsers *)users {
    if (self = [super init]) {
        self.users = users;
    }
    return self;
}

- (void)registerWithAccount:(NSString *)account password:(NSString *)password name:(NSString *)name success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    [HttpRequest POSTWithURL:[URL registerUser] parameters:@{@"email":account,@"name":name,@"password":[password MD5Hash]} success:^(id data) {
        
        if (success) {
            success();
        }
    } failure:failure];
}

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(Y2WCurrentUser *))success
                 failure:(void (^)(NSError *))failure {
    
    if (!password) {
        if (failure) {
            failure([NSError errorWithDomain:@"yun2win" code:100 userInfo:@{@"message": @"密码不能为空"}]);
        }
        return;
    }
    
    CurrentUserBase *base = [CurrentUserBase objectsWhere:@"email == %@ AND password == %@", account.lowercaseString, password].firstObject;
    if (base && ([base.loginDate hoursEarlierThan:[NSDate date]] < 6)) {
        Y2WCurrentUser *currentUser = [[Y2WCurrentUser alloc] initWithBase:base];
        self.users.currentUser = currentUser;
        // 启动一次同步
        [currentUser.userConversations.remote sync:nil];
        [currentUser.contacts.remote sync:nil];
        
        if (success) {
            success(currentUser);
        }
        return;
    }

    [HttpRequest POSTWithURL:[URL login] parameters:@{@"email":account,@"password":[password MD5Hash]} success:^(NSDictionary *data) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            CurrentUserBase *base = [CurrentUserBase createOrUpdateInDefaultRealmWithValue:data];
            base.password = password;
            base.loginDate = [NSDate date];
        }];
        [self loginWithAccount:account password:password success:success failure:failure];

    } failure:failure];
}

- (void)searchUserWithKey:(NSString *)key success:(void (^)(NSArray *users))success failure:(void (^)(NSError *error))failure {
    
    [HttpRequest GETWithURL:[URL getUsers] parameters:@{@"filter_term":key} success:^(id data) {
        NSMutableArray *users = [NSMutableArray array];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            for (NSDictionary *dict in data[@"entries"]) {
                UserBase *base = [UserBase createOrUpdateInDefaultRealmWithValue:dict];
                [users addObject:[self.users addOrUpdateUserWithBase:base]];
            }
        }];

        if (success) success(users);
    } failure:failure];
}

- (void)getUserById:(NSString *)userId success:(void (^)(Y2WUser *))success failure:(void (^)(NSError *))failure {
    Y2WUser *user = [self.users getUserById:userId];
    if (user.lastUpdate && [user.lastUpdate secondsEarlierThan:[NSDate date]] < 30) {
        if (success) {
            success(user);
        }
        return;
    }

    [HttpRequest GETWithURL:[URL aboutUser:userId] parameters:nil success:^(id data) {
        
        [[RLMRealm defaultRealm] beginWriteTransaction];
        UserBase *base = [UserBase createOrUpdateInDefaultRealmWithValue:data];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        Y2WUser *user = [self.users addOrUpdateUserWithBase:base];
        user.lastUpdate = [NSDate date];

        if (success) success(user);
    } failure:failure];
}

- (void)getUserByIds:(NSArray<NSString *> *)uids success:(void (^)(NSArray<Y2WUser *> *))success failure:(void (^)(NSError *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
        
        NSMutableArray *users = [NSMutableArray array];
        __block NSError *failureError = nil;
        
        for (NSString *uid in uids) {
            
            [self getUserById:uid success:^(Y2WUser *user) {
                [users addObject:user];
                
                dispatch_semaphore_signal(dispatchSemaphore);
            } failure:^(NSError *error) {
                failureError = error;
                dispatch_semaphore_signal(dispatchSemaphore);
            }];
        
            dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
            
            if (failureError) {
                if (failure) failure(failureError);
                return;
            }
        }
        if (success) {
            success(users);
        }
    });
}

@end

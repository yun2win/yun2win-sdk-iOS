//
//  Y2WCurrentUser.m
//  API
//
//  Created by ShingHo on 16/3/3.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WCurrentUser.h"
#import "LoginManager.h"

NSErrorDomain const Y2WCurrentUserErrorDomain = @"Y2WCurrentUserErrorDomain";

@implementation Y2WCurrentUser

- (instancetype)initWithBase:(CurrentUserBase *)base {
    if (self = [super initWithBase:base]) {
        self.contacts = [[Y2WContacts alloc] initWithCurrentUser:self];
        self.sessions = [[Y2WSessions alloc] initWithCurrentUser:self];
        self.userConversations = [[Y2WUserConversations alloc] initWithCurrentUser:self];
        self.attachments = [[Y2WAttachments alloc] initWithCurrentUser:self];
        self.remote = [[Y2WCurrentUserRemote alloc] initWithCurrentUser:self];
        self.bridge = [[Y2WIMBridge alloc] initWithCurrentUser:self];
    }
    return self;
}

- (void)updateWithBase:(CurrentUserBase *)base {
    [super updateWithBase:base];
    self.appKey   = base.appkey;
    self.secret   = base.secret;
    self.token    = base.token;
    self.password = base.password;
    self.authorization = [@"Bearer " stringByAppendingString:self.token];
}


- (void)setPassword:(NSString *)password {
    _password = password.copy;
    [[LoginManager sharedManager] setPassword:password];
    [[LoginManager sharedManager] login];
}


- (RLMRealm *)realm {
    return [RLMRealm realmWithURL:[NSURL URLWithString:[NSString realmPathForUID:self.ID]]];
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.ID) dict[@"id"] = self.ID;
    if (self.name) dict[@"name"] = self.name;
    if (self.pinyin) dict[@"pinyin"] = self.pinyin;
    if (self.avatarUrl) dict[@"avatarUrl"] = self.avatarUrl;
    if (self.email) dict[@"email"] = self.email;
    if (self.phone) dict[@"phone"] = self.phone;
    return dict;
}


@end





@interface Y2WCurrentUserRemote ()

@property (nonatomic, weak) Y2WCurrentUser *currentUser;

@end


@implementation Y2WCurrentUserRemote

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser {
    if (self = [super init]) {
        self.currentUser = currentUser;
    }
    return self;
}


- (void)setPassword:(NSString *)password fromOldPassword:(NSString *)oldPassword completion:(void (^)(NSError *))block {
    if (!password.length || !oldPassword.length) {
        if (block) {
            block([NSError errorWithDomain:Y2WCurrentUserErrorDomain code:1001 userInfo:@{@"message": @"密码不能为空"}]);
        }
        return;
    }
    if (password.length < 6) {
        if (block) {
            block([NSError errorWithDomain:Y2WCurrentUserErrorDomain code:1002 userInfo:@{@"message": @"密码长度不能少于6位字符"}]);
        }
        return;
    }
    if (password.length > 20) {
        if (block) {
            block([NSError errorWithDomain:Y2WCurrentUserErrorDomain code:1003 userInfo:@{@"message": @"密码长度不能超过20位字符"}]);
        }
        return;
    }
    if ([password isEqualToString:oldPassword]) {
        if (block) {
            block([NSError errorWithDomain:Y2WCurrentUserErrorDomain code:1004 userInfo:@{@"message": @"新密码不能与旧密码相同"}]);
        }
        return;
    }
    
    [HttpRequest POSTWithURL:[URL setPassword]
                  parameters:@{@"oldPassword": oldPassword.MD5Hash, @"password": password.MD5Hash}
                     success:^(id data) {
                         RLMRealm *realm = [RLMRealm defaultRealm];
                         CurrentUserBase *base = [CurrentUserBase objectForPrimaryKey:self.currentUser.ID];
                         [realm transactionWithBlock:^{
                             [base setPassword:password];
                         }];
                         [self.currentUser updateWithBase:base];
                         if (block) block(nil);
                         
                     } failure:block];
}


- (void)store:(void (^)(NSError *))block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.currentUser.email) parameters[@"email"] = self.currentUser.email;
    if (self.currentUser.name) parameters[@"name"] = self.currentUser.name;
    if (self.currentUser.avatarUrl) parameters[@"avatarUrl"] = self.currentUser.avatarUrl;
    
    [HttpRequest PUTWithURL:[URL aboutUser:self.currentUser.ID] parameters:parameters success:^(id data) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            CurrentUserBase *base = [CurrentUserBase createOrUpdateInDefaultRealmWithValue:data];
            [self.currentUser updateWithBase:base];
        }];

#warning Todo 通知其它设备
//        [self.currentUser.bridge sendOtherDeviceMessages:@[@{@"type":@4}]];

        
        if (block) {
            block(nil);
        }
    } failure:block];
}





- (void)sync:(void (^)(NSError *))block {
    [HttpRequest POSTWithURL:[URL login] parameters:@{@"email":self.currentUser.email,@"password":self.currentUser.password.MD5Hash} success:^(id data) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            CurrentUserBase *base = [CurrentUserBase createOrUpdateInDefaultRealmWithValue:data];
            [self.currentUser updateWithBase:base];
        }];
        if (block) block(nil);
    } failure:block];
}



- (void)syncIMToken:(void (^)(NSError *))block {
    [HttpRequest POSTNoHeaderWithURL:[URL getImToken] parameters:@{@"grant_type":@"client_credentials",@"client_id":self.currentUser.appKey,@"client_secret":self.currentUser.secret} success:^(id data) {
        self.currentUser.imToken = data[@"access_token"];
        if (block) {
            block(nil);
        }
    } failure:^(NSError *error) {
        if (error.code == NSURLErrorBadServerResponse) {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if (response.statusCode == 400) {
                return [HttpRequest POSTWithURL:[URL login] parameters:@{@"email":self.currentUser.email,@"password":[self.currentUser.password MD5Hash]} success:^(NSDictionary *data) {
                    [[RLMRealm defaultRealm] transactionWithBlock:^{
                        CurrentUserBase *base = [CurrentUserBase createOrUpdateInDefaultRealmWithValue:data];
                        base.loginDate = [NSDate date];
                    }];
                    [self syncIMToken:block];
                } failure:block];
            }
        }
        
        if (block) {
            block(error);
        }
    }];
}

@end

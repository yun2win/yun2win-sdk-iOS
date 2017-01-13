//
//  DataMigration.m
//  yun2win
//
//  Created by QS on 2016/12/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataMigration.h"

@implementation DataMigration

+ (void)migrate {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {
//            [migration enumerateObjects:Person.className
//                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
//                                      
//                                      // combine name fields into a single field
//                                      newObject[@"fullName"] = [NSString stringWithFormat:@"%@ %@",
//                                                                oldObject[@"firstName"],
//                                                                oldObject[@"lastName"]];
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

@end

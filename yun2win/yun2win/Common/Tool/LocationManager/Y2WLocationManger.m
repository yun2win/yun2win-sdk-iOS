//
//  Y2WLocationManger.m
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#define INTU_ENABLE_LOGGING 0
NSErrorDomain const Y2WLocationMangerErrorDomain = @"Y2WLocationMangerErrorDomain";

#import "Y2WLocationManger.h"
@import INTULocationManager;

@interface Y2WLocationManger ()

@property (nonatomic, retain) CLGeocoder *geocoder;

@end



@implementation Y2WLocationManger

- (void)getCurrentLocation:(void (^)(NSError *, CLLocation *))block {
    if (!block) {
        return;
    }
    
    NSError *error = [self errorWithServicesState];
    if (error) {
        return block(error, nil);
    }
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 block(nil, currentLocation);
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 block([NSError errorWithDomain:Y2WLocationMangerErrorDomain code:1 userInfo:@{@"message": @"获取地理位置超时"}], nil);
                                             }
                                             else {
                                                 block([NSError errorWithDomain:Y2WLocationMangerErrorDomain code:1 userInfo:@{@"message": @"获取地理位置失败"}], nil);
                                             }
                                         }];
}

- (void)getCurrentLocationInfo:(void (^)(NSError *, NSDictionary *))block {
    if (!block) {
        return;
    }
 
    NSError *error = [self errorWithServicesState];
    if (error) {
        return block(error, nil);
    }
    
    [self getCurrentLocation:^(NSError *error, CLLocation *location) {
        if (error) {
            return block([NSError errorWithDomain:Y2WLocationMangerErrorDomain code:1 userInfo:@{@"message": @"坐标解析失败"}], nil);
        }
        
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *firstPlacemark = [placemarks firstObject];
            CLLocationDegrees latitude = location.coordinate.latitude;
            CLLocationDegrees longitude = location.coordinate.longitude;
            NSString *name = firstPlacemark.name ?: @"";
        
            block(error, @{@"latitude": @(latitude),
                           @"longitude": @(longitude),
                           @"address": name});
        }];
    }];
}







#pragma mark - Helper

- (NSError *)errorWithServicesState {
    if (INTULocationManager.locationServicesState == INTULocationServicesStateDenied) {
        return [NSError errorWithDomain:Y2WLocationMangerErrorDomain
                                   code:1
                               userInfo:@{@"message": @"您的手机目前未开启定位服务，如需开启定位服务，请至设置->隐私->定位服务，开启本程序的定位服务功能"}];
    }
    return nil;
}



#pragma mark - Getter

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end

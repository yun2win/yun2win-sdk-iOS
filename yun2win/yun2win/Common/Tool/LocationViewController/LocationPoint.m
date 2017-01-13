//
//  LocationPoint.m
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "LocationPoint.h"

@implementation LocationPoint

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate Title:(NSString *)title addressImage:(UIImage *)image imagePath:(NSString *)imagePath {
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
        _image = image;
        _imagePath = imagePath;
    }
    return self;
}

- (instancetype)initWithMessage:(Y2WLocationMessage *)message
{
    if (self = [super init]) {
        CLLocationCoordinate2D coodinate;
        coodinate.longitude = [message.content[@"longitude"] doubleValue];
        coodinate.latitude = [message.content[@"latitude"] doubleValue];
        self.title = message.title;
        _coordinate = coodinate;
        _image = nil;
        _imagePath = @"";
    }
    return self;
}

@end

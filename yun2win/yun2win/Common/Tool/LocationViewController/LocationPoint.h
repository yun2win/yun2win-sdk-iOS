//
//  LocationPoint.h
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationPoint : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *imagePath;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate Title:(NSString *)title addressImage:(UIImage *)image imagePath:(NSString *)imagePath;

- (instancetype)initWithMessage:(Y2WLocationMessage *)message;

@end

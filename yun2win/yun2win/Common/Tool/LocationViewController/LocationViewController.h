//
//  LocationViewController.h
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class LocationPoint;

@interface LocationViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

- (instancetype)initWithHandler:(void(^)(LocationPoint *point))handler;

- (instancetype)initWithLocationPoint:(LocationPoint *)locationPoint;

@end

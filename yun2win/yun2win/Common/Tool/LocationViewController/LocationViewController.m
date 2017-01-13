//
//  LocationViewController.m
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LocationPoint.h"

@interface LocationViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) UIBarButtonItem *sendButton;

@property (nonatomic, strong) LocationPoint *locationPoint;

@property (nonatomic, copy) void(^handler)(LocationPoint *);

@end

@implementation LocationViewController

- (instancetype)initWithHandler:(void (^)(LocationPoint *))handler {
    if (self = [super init]) {
        self.handler = handler;
        self.editing = YES;
    }
    return self;
}

- (instancetype)initWithLocationPoint:(LocationPoint *)locationPoint
{
    if (self = [super init]) {
        _locationPoint = locationPoint;
        self.editing = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.mapView];
    [self.locationManager startUpdatingLocation];
    if ([CLLocationManager locationServicesEnabled]) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
            [self.locationManager requestAlwaysAuthorization];
        }
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied)
        {
            [self showLocationPermission];
        }
        else    self.mapView.showsUserLocation = YES;
    }
    else
    {
        [self showLocationPermission];
    }
    
    
    if (self.editing) {
        [self setUpRightNavButton];
        self.locationPoint = [[LocationPoint alloc] initWithCoordinate:self.mapView.userLocation.coordinate Title:nil addressImage:nil imagePath:nil];
    }
    [self.mapView addAnnotation:self.locationPoint];
    
    if (!self.editing) {
        [self.mapView selectAnnotation:self.locationPoint animated:YES];
    }
    [self backCurrentLocation:nil];
    
    //当前位置
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, self.view.frame.size.height - 40.0f - 20.0f, 40.0f, 40.0f)];
    [btn setImage:[UIImage y2w_imageNamed:@"地图-定位"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

- (void)setUpRightNavButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onSend:)];
    self.navigationItem.rightBarButtonItem = item;
    self.sendButton = item;
    self.sendButton.enabled = NO;
}

- (void)showLocationPermission {
    [UIAlertView showTitle:@"提示" message:@"您的手机目前未开启定位服务，如需开启定位服务，请至设置->隐私->定位服务，开启本程序的定位服务功能"];
}

- (void)backCurrentLocation:(UIButton *)but {
    MKCoordinateRegion theRegion;
    theRegion.center = self.editing ? self.mapView.userLocation.coordinate : self.locationPoint.coordinate;
    theRegion.span.longitudeDelta	= 0.01f;
    theRegion.span.latitudeDelta	= 0.01f;
    [self.mapView setRegion:theRegion animated:YES];
}

- (void)onSend:(id)sender {
    
    CGFloat scale = UIScreen.mainScreen.scale;
    CGRect rect = CGRectMake(0, 200 * scale, self.mapView.frame.size.width * scale, 220 * scale);
    UIImage *image = [self.mapView.screenshot imageWithRect:rect];
    NSString *imgPath = [image writeJPGToQuality:0.5];
    
    self.locationPoint.image = image;
    self.locationPoint.imagePath = imgPath;
    
    if (self.handler) {
        self.handler(self.locationPoint);
    }
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    [self.locationPoint setCoordinate:centerCoordinate];
    [self reverseGeoLocation:centerCoordinate];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    self.sendButton.enabled = fullyRendered;
}

- (void)reverseGeoLocation:(CLLocationCoordinate2D)locationCoordinate2D{
    if (self.geoCoder.isGeocoding) {
        [self.geoCoder cancelGeocode];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate2D.latitude
                                                      longitude:locationCoordinate2D.longitude];
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error) {
                                return;
                            }
                            CLPlacemark *mark = [placemarks lastObject];
                            self.locationPoint.title  = mark.formattedAddress;
                            [self.mapView removeAnnotation:self.locationPoint];
                            [self.mapView addAnnotation:self.locationPoint];
                            [self.mapView selectAnnotation:self.locationPoint animated:YES];
     }];
}


#pragma mark - 初始化
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.frame = self.view.bounds;
        if (self.editing) {
            _mapView.delegate = self;
        }
    }
    return _mapView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

- (CLGeocoder *)geoCoder {
    if(!_geoCoder)
    {
        _geoCoder = [[CLGeocoder alloc]init];
    }
    return _geoCoder;
}

@end

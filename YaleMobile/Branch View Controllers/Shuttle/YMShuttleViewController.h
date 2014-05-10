//
//  YMShuttleViewController.h
//  YaleMobile
//
//  Created by iBlue on 12/27/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YMShuttleViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView1;
@property (nonatomic, strong) UIManagedDocument *db;
@property (nonatomic) double zoomLevel;
@property (nonatomic, strong) UIView *callout;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, strong) NSArray *etaData;
@property (nonatomic) NSInteger locating;
@property (nonatomic, strong) IBOutlet UIButton *locate1;
@property (nonatomic, strong) IBOutlet UIButton *refresh1;
@property (nonatomic, strong) NSString *routesList;

@end

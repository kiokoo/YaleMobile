//
//  YMMapViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

@class YMMapViewAnnotation;

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YMMapViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) UIView *searchOverlay;
@property (nonatomic, strong) UIButton *locate;
@property (nonatomic) NSInteger locating;
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic) BOOL zoomForAnnotation;
@property (nonatomic, strong) YMMapViewAnnotation *annotation;

@property (nonatomic, strong) UIManagedDocument *database;

@end

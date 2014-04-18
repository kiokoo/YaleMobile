//
//  YMShuttleViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/27/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

// Yale = 132

#import "YMShuttleViewController.h"
#import "YMGlobalHelper.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMShuttleSelectionViewController.h"
#import "YMServerCommunicator.h"
#import "Route+Initialize.h"
#import "Stop+Initialize.h"
#import "Segment+Initialize.h"
#import "YMDatabaseHelper.h"
#import "MKPolyline+EncodedString.h"
#import "YMStopAnnotation.h"
#import "YMStopAnnotationView.h"
#import "YMTransferStopAnnotationView.h"
#import "YMStopInfoSubview.h"
#import "YMRoundView.h"
#import "YMVehicleAnnotation.h"
#import "YMVehicleAnnotationView.h"
#import "Vehicle+Initialize.h"
#import "YMVehicleInfoSubview.h"
#import "MBProgressHUD.h"

@interface YMShuttleViewController ()

@end

@implementation YMShuttleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YMGlobalHelper addMenuButtonToController:self];
    
    UIButton *settings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 25)];
    [settings setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:settings]];
    [settings addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    self.zoomLevel = 0;
    [self.locate addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [self.refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Shuttle Refresh"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidReset:) name:ECSlidingViewTopDidReset object:self.slidingViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [YMServerCommunicator cancelAllHTTPRequests];

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [YMGlobalHelper setupRightSlidingViewControllerForController:self withRightController:[YMShuttleSelectionViewController class] named:@"Shuttle Selection"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Resumed"];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.3123;
    zoomLocation.longitude = -72.9281;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, span);
    [self.mapView setRegion:region animated:YES];
        
    if ((self.db = [YMDatabaseHelper getManagedDocument])) {
        [self loadData];
    } else {
        [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {
            self.db = document;
            [YMDatabaseHelper setManagedDocumentTo:document];
            [self loadData];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Disappeared");
    [self.refresh setSelected:NO];
    [self removeCalloutViewWithAnimation];
}

- (void)topDidReset:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Shuttle Refresh"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Shuttle Refresh"];
        [self.refresh setSelected:NO];
        
        [self removeCalloutViewWithAnimation];
        
        [self loadData];
    }
}

- (void)loadData
{
    NSTimeInterval interval = [YMGlobalHelper getTimestamp];
    [Route removeRoutesBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [Stop removeStopsBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [Segment removeSegmentsBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [Vehicle removeVehiclesBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [YMServerCommunicator getRouteInfoForController:self usingBlock:^(NSArray *data) {
        for (NSDictionary *dict in data)
            [Route routeWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
        NSArray *routes = [Route getAllRoutesInManagedObjectContext:self.db.managedObjectContext];
        YMShuttleSelectionViewController *ssvc = (YMShuttleSelectionViewController *)self.slidingViewController.underRightViewController;
        ssvc.routes = routes;
        
        NSString *r = [Route getActiveRoutesInManagedObjectContext:self.db.managedObjectContext];
        self.routesList = r;
        if (!r) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"No active route selected"];
            hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(alertViewCallback) userInfo:nil repeats:NO];
            return;
        } else {
            [YMServerCommunicator getStopInfoForController:self usingBlock:^(NSArray *data) {
                for (NSDictionary *dict in data)
                    [Stop stopWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
                [YMServerCommunicator getSegmentInfoForController:self andRoutes:r usingBlock:^(NSDictionary *data) {
                    for (NSString *key in [data allKeys])
                        [Segment segmentWithID:[key integerValue] andEncodedString:[data objectForKey:key] inManagedObjectContext:self.db.managedObjectContext];
                    [YMServerCommunicator getShuttleInfoForController:self andRoutes:r usingBlock:^(NSArray *data) {
                        for (NSDictionary *dict in data) {
                            [Vehicle vehicleWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
                        }
                        [self addSegments];
                        [self addStops];
                        [self addVehicles];
                        [self.refresh setSelected:YES];
                        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(refreshVehicles) userInfo:nil repeats:NO];
                    }];
                }];
            }];
        }
    }];
}

- (void)alertViewCallback
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)addSegments
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
     
    for (Segment *s in matches) {
        NSArray *routes = [s.routes allObjects];
        for (Route *r in routes) {
            MKPolyline *line = [MKPolyline polylineWithEncodedString:s.string];
            line.title = r.color;
            line.subtitle = [NSString stringWithFormat:@"%d:%d", [routes indexOfObject:r], routes.count];
            [self.mapView addOverlay:line];
        }
    }
}

- (void)addStops
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"stopid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
    
    for (Stop *s in matches) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(s.latitude.doubleValue, s.longitude.doubleValue);
        YMStopAnnotation *annotation = [[YMStopAnnotation alloc] initWithLocation:coordinate routes:[s.routes allObjects] stop:s title:s.name andSubtitle:s.code.stringValue];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)addVehicles
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vehicle"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"vehicleid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
    
    for (Vehicle *v in matches) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(v.latitude.doubleValue, v.longitude.doubleValue);
        BOOL found = NO;
        for (id a in self.mapView.annotations) {
            if ([a isKindOfClass:[YMVehicleAnnotation class]]) {
                if (((YMVehicleAnnotation *)a).vehicle.vehicleid.integerValue == v.vehicleid.integerValue) {
                    found = YES;
                    YMVehicleAnnotationView *vav = (YMVehicleAnnotationView *)[self.mapView viewForAnnotation:a];
                    [UIView animateWithDuration:2 animations:^{
                        [a updateCoordinate:coordinate andVehicle:v];
                    }completion:^(BOOL finished) {
                        [vav setNeedsDisplay];
                    }];
                    break;
                }
            }
        }
        if (!found) {
            YMVehicleAnnotation *annotation = [[YMVehicleAnnotation alloc] initWithLocation:coordinate vehicle:v title:nil andSubtitle:nil];
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void)locate:(id)sender
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"Location service is turned off for YaleMobile. If you would like to grant YaleMobile access, please go to Settings - Location Services." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.locating) {
        self.locating = 0;
        self.mapView.showsUserLocation = NO;
        [self.locate setSelected:NO];
    } else {
        self.locating = 1;
        self.mapView.showsUserLocation = YES;
        [self.locate setSelected:YES];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.strokeColor = [[YMGlobalHelper colorFromHexString:overlay.title] colorWithAlphaComponent:1];
        lineView.lineWidth = 5.0;
        
        NSArray *routes = [overlay.subtitle componentsSeparatedByString:@":"];
        NSInteger routesCount = [[routes objectAtIndex:1] integerValue];
        if (routesCount > 1) {
            lineView.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:30 * ([[routes objectAtIndex:1] integerValue] - 1)], nil];
            lineView.lineDashPhase = [[routes objectAtIndex:0] floatValue] * 30;
        }
        return lineView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    if ([annotation isKindOfClass:[YMStopAnnotation class]]) {
        MKAnnotationView *stopView = nil;
        if (((YMStopAnnotation *) annotation).routes.count == 1) {
            stopView = (YMStopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Stop View"];
            if (!stopView) stopView = [[YMStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Stop View"];
            else stopView.annotation = annotation;
        } else {
            stopView = (YMTransferStopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Transfer View"];
            if (!stopView) stopView = [[YMTransferStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Transfer View"];
            else stopView.annotation = annotation;
        }
        stopView.canShowCallout = NO;
        [stopView setNeedsDisplay];
        return stopView;
    }
    
    if ([annotation isKindOfClass:[YMVehicleAnnotation class]]) {
        YMVehicleAnnotationView *vehicleView = (YMVehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Vehicle View"];
        if (!vehicleView) vehicleView = [[YMVehicleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Vehicle View"];
        else vehicleView.annotation = annotation;
        vehicleView.canShowCallout = NO;
        [vehicleView setNeedsDisplay];
        return vehicleView;
    }

    return nil;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    double span = mapView.region.span.longitudeDelta;
    if (span > 0.021 && self.zoomLevel <= 0.021) {
        [mapView removeAnnotations:mapView.annotations];
        [self addVehicles];
    } else if (span <= 0.021 && self.zoomLevel > 0.021) {
        [self addStops];
    }
    self.zoomLevel = span;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.locating == 1 && userLocation.location.coordinate.latitude != 0) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.locating = 2;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCallout:)];
    [self.mapView addGestureRecognizer:rec];
    
    if ([view isKindOfClass:[YMStopAnnotationView class]] || [view isKindOfClass:[YMTransferStopAnnotationView class]]) {
        [YMServerCommunicator getArrivalEstimateForStop:((YMStopAnnotation *)view.annotation).s.stopid.stringValue forController:self andRoutes:self.routesList usingBlock:^(NSArray *array) {
            NSMutableDictionary *md = [[NSMutableDictionary alloc] initWithCapacity:array.count];
            for (Route *r in ((YMStopAnnotation *)view.annotation).routes)
                [md setObject:@"--" forKey:r.routeid.stringValue];
            for (NSDictionary *d in array) {
                NSString *routeid = [d objectForKey:@"route_id"];
                NSString *minute = [md objectForKey:routeid];
                NSString *newMinute = [YMGlobalHelper minutesFromString:[d objectForKey:@"arrival_at"]];
                if (!minute) continue;
                if ([minute isEqualToString:@"--"] || [YMGlobalHelper minutesFromString:minute].integerValue > newMinute.integerValue) [md setObject:[d objectForKey:@"arrival_at"] forKey:routeid];
            }
            NSMutableArray *etaArray = [[NSMutableArray alloc] initWithCapacity:md.count * 2];
            for (Route *r in ((YMStopAnnotation *)view.annotation).routes) {
                [etaArray addObject:r];
                [etaArray addObject:[md objectForKey:r.routeid.stringValue]];
                NSLog(@"ETA Array contains %@", [md objectForKey:r.routeid.stringValue]);
            }
            self.etaData = etaArray;
            [self refreshCalloutEta];
        }];
        
        YMStopInfoSubview *stopView = nil;
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YMStopInfoSubview" owner:self options:nil];
        for (id v in views) {
            if ([v isKindOfClass:[YMStopInfoSubview class]]) {
                YMStopAnnotation *sa = (YMStopAnnotation *)view.annotation;
                stopView = (YMStopInfoSubview *)v;
                stopView.index = 1;
                stopView.minutes.text = @"--";
                stopView.lineName.text = ((Route *)[sa.routes objectAtIndex:0]).name;
                stopView.stopName.text = sa.title;
                stopView.stopCode.text = sa.subtitle;
                stopView.etaLabel.text = @"--:--";
                YMRoundView *roundView = [[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:((Route *)[sa.routes objectAtIndex:0]).color] andFrame:CGRectMake(26, 43, 13, 13)];
                [stopView addSubview:roundView];
                stopView.dot1 = roundView;
            }
        }
        
        float delay = 0;
        if (self.callout) {
            [self.animationTimer invalidate];
            delay = 0.3;
            CGRect frame = self.callout.frame;
            frame.origin.y -= 100;
            [UIView animateWithDuration:0.3 animations:^{
                self.callout.frame = frame;
            } completion:^(BOOL finished) {
                [self removeCalloutView];
            }];
        }
        
        [self.view addSubview:stopView];
        CGRect frame = stopView.frame;
        frame.origin.y -= 100;
        stopView.frame = frame;
        frame.origin.y += 100;
        
        [UIView animateWithDuration:0.3 delay:delay options:nil animations:^{
            stopView.frame = frame;
        } completion:^(BOOL finished) {
            self.callout = stopView;
            [self refreshCalloutEta];
        }];
    }
    
    if ([view isKindOfClass:[YMVehicleAnnotationView class]]) {
        YMVehicleInfoSubview *vehicleView = nil;
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YMVehicleInfoSubview" owner:self options:nil];
        for (id v in views) {
            if ([v isKindOfClass:[YMVehicleInfoSubview class]]) {
                YMVehicleAnnotation *va = (YMVehicleAnnotation *)view.annotation;
                vehicleView = (YMVehicleInfoSubview *)v;
                if (va.vehicle.nextstop) {
                    vehicleView.stop.text = va.vehicle.nextstop.name;
                    vehicleView.nextStop.text = [NSString stringWithFormat:@"Next Stop - arriving at %@", [YMGlobalHelper dateStringFromString:va.vehicle.arrivaltime]];
                } else {
                    vehicleView.stop.text = @"Vehicle Off Route";
                    vehicleView.nextStop.text = @"Next Stop";
                }
                vehicleView.route.text = va.vehicle.route.name;
                vehicleView.vehicleNumber.text = [NSString stringWithFormat:@"#%@", va.vehicle.name];
                YMRoundView *roundView = [[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:va.vehicle.route.color] andFrame:CGRectMake(26, 14, 13, 13)];
                [vehicleView addSubview:roundView];
            }
        }
        
        float delay = 0;
        if (self.callout) {
            [self.animationTimer invalidate];
            delay = 0.3;
            CGRect frame = self.callout.frame;
            frame.origin.y -= 100;
            [UIView animateWithDuration:0.3 animations:^{
                self.callout.frame = frame;
            } completion:^(BOOL finished) {
                [self removeCalloutView];
            }];
        }
        
        [self.view addSubview:vehicleView];
        CGRect frame = vehicleView.frame;
        frame.origin.y -= 100;
        vehicleView.frame = frame;
        frame.origin.y += 100;
        
        [UIView animateWithDuration:0.3 delay:delay options:nil animations:^{
            vehicleView.frame = frame;
        } completion:^(BOOL finished) {
            self.callout = vehicleView;
        }];
    }
}

- (void)removeCalloutView
{
    [self.callout removeFromSuperview];
    self.callout = nil;
    self.etaData = nil;
}

- (void)removeCalloutViewWithAnimation
{
    if (self.callout) {
        [self.animationTimer invalidate];
        CGRect frame = self.callout.frame;
        frame.origin.y -= 100;
        [UIView animateWithDuration:0.3 animations:^{
            self.callout.frame = frame;
        } completion:^(BOOL finished) {
            [self removeCalloutView];
        }];
    }
}

- (void)dismissCallout:(UITapGestureRecognizer *)rec
{
    [self.mapView removeGestureRecognizer:rec];
    [self removeCalloutViewWithAnimation];
}

- (void)refreshCalloutEta
{
    if ([self.callout isKindOfClass:[YMStopInfoSubview class]]) {
        if (self.etaData) {
            ((YMStopInfoSubview *)self.callout).minutes.text = [YMGlobalHelper minutesFromString:[self.etaData objectAtIndex:1]];
            ((YMStopInfoSubview *)self.callout).etaLabel.text = [YMGlobalHelper dateStringFromString:[self.etaData objectAtIndex:1]];
            if (self.etaData.count > 2) [self animateStopCallout:(YMStopInfoSubview *)self.callout withInfo:self.etaData];
        }
    }
}

- (void)refresh:(id)sender
{
    if (self.refresh.selected) [self.refresh setSelected:NO];
    else {
        [self.refresh setSelected:YES];
        [self refreshVehicles];
    }
}

- (void)refreshVehicles
{
    if (self.refresh.selected) {
        NSLog(@"Refreshing Vehicles");
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Resumed"]) {
            [self loadData];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Resumed"];
        } else {
            [YMServerCommunicator getShuttleInfoForController:nil andRoutes:self.routesList usingBlock:^(NSArray *array) {
                if (array.count) {
                    NSTimeInterval interval = [YMGlobalHelper getTimestamp];
                    for (NSDictionary *dict in array) {
                        [Vehicle vehicleWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
                    }
                    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(refreshVehicles) userInfo:nil repeats:NO];
                    [self addVehicles];
                } else {
                    NSLog(@"Deselected");
                    [self.refresh setSelected:NO];
                }
            }];
        }
    }
}

- (void)animateStopCallout:(YMStopInfoSubview *)view withInfo:(NSArray *)info
{
    // hide single route stop labels
    view.minutes.hidden = YES;
    view.lineName.hidden = YES;
    view.etaLabel.hidden = YES;
    
    UILabel *minutes1 = [[UILabel alloc] initWithFrame:CGRectMake(33, 23, 55, 35)];
    minutes1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:42];
    minutes1.textColor = [UIColor colorWithRed:184/255.0 green:230/255.0 blue:1 alpha:1];
    minutes1.textAlignment = NSTextAlignmentRight;
    minutes1.backgroundColor = [UIColor clearColor];
    minutes1.text = [YMGlobalHelper minutesFromString:[self.etaData objectAtIndex:1]];
    
    UILabel *minutes2 = [[UILabel alloc] initWithFrame:CGRectMake(33, -20, 55, 35)];
    minutes2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:42];
    minutes2.textColor = [UIColor colorWithRed:184/255.0 green:230/255.0 blue:1 alpha:1];
    minutes2.textAlignment = NSTextAlignmentRight;
    minutes2.backgroundColor = [UIColor clearColor];
    minutes2.text = [YMGlobalHelper minutesFromString:[self.etaData objectAtIndex:3]];
    minutes2.alpha = 0;
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 170, 21)];
    line1.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    line1.textColor = [UIColor whiteColor];
    line1.backgroundColor = [UIColor clearColor];
    line1.text = ((Route *)[info objectAtIndex:0]).name;
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(6, -20, 170, 21)];
    line2.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    line2.textColor = [UIColor whiteColor];
    line2.backgroundColor = [UIColor clearColor];
    line2.alpha = 0;
    line2.text = ((Route *)[info objectAtIndex:2]).name;
    
    UILabel *eta1 = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 50, 21)];
    eta1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    eta1.textColor = [UIColor lightGrayColor];
    eta1.backgroundColor = [UIColor clearColor];
    eta1.text = [YMGlobalHelper dateStringFromString:[self.etaData objectAtIndex:1]];
    
    UILabel *eta2 = [[UILabel alloc] initWithFrame:CGRectMake(28, -10, 50, 21)];
    eta2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    eta2.textColor = [UIColor lightGrayColor];
    eta2.backgroundColor = [UIColor clearColor];
    eta2.text = [YMGlobalHelper dateStringFromString:[self.etaData objectAtIndex:3]];
    eta2.alpha = 0;
    
    YMRoundView *roundView = [[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:((Route *)[info objectAtIndex:2]).color] andFrame:CGRectMake(26, 43, 13, 13)];
    [view addSubview:roundView];
    roundView.alpha = 0;
    view.dot2 = roundView;
    
    [view.minutesFrame addSubview:minutes1];
    [view.minutesFrame addSubview:minutes2];
    [view.lineFrame addSubview:line1];
    [view.lineFrame addSubview:line2];
    [view.etaFrame addSubview:eta1];
    [view.etaFrame addSubview:eta2];
    
    view.minutes1 = minutes1;
    view.minutes2 = minutes2;
    view.line1 = line1;
    view.line2 = line2;
    view.eta1 = eta1;
    view.eta2 = eta2;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animate:) userInfo:info repeats:YES];
    self.animationTimer = timer;
}

- (void)animate:(NSTimer *)timer
{
    if (!self.callout || ![self.callout isKindOfClass:[YMStopInfoSubview class]]) {
        [timer invalidate];
        return;
    }
    NSArray *data = (NSArray *)timer.userInfo;
    YMStopInfoSubview *view = (YMStopInfoSubview *)self.callout;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.minutes1.alpha = 0;
        view.minutes2.alpha = 1;
        view.minutes1.frame = CGRectMake(33, 60, 55, 35);
        view.minutes2.frame = CGRectMake(33, 23, 55, 35);
        view.line1.alpha = 0;
        view.line2.alpha = 1;
        view.line1.frame = CGRectMake(6, 25, 170, 21);
        view.line2.frame = CGRectMake(6, 6, 170, 21);
        view.dot1.alpha = 0;
        view.dot2.alpha = 1;
        view.eta1.alpha = 0;
        view.eta2.alpha = 1;
        view.eta1.frame = CGRectMake(28, 15, 50, 21);
        view.eta2.frame = CGRectMake(28, 0, 50, 21);
    } completion:^(BOOL finished) {
        view.minutes1.alpha = 1;
        view.minutes2.alpha = 0;
        view.minutes1.frame = CGRectMake(33, 23, 55, 35);
        view.minutes2.frame = CGRectMake(33, -20, 55, 35);
        view.minutes1.text = [YMGlobalHelper minutesFromString:[data objectAtIndex:(view.index * 2 + 1)]];
        view.eta1.text = [YMGlobalHelper dateStringFromString:[data objectAtIndex:(view.index * 2 + 1)]];
        view.line1.alpha = 1;
        view.line2.alpha = 0;
        view.line1.frame = CGRectMake(6, 6, 170, 21);
        view.line2.frame = CGRectMake(6, -20, 170, 21);
        view.line1.text = ((Route *)[data objectAtIndex:(view.index * 2)]).name;
        [view.dot1 redrawWithColor:[YMGlobalHelper colorFromHexString:((Route *)[data objectAtIndex:(view.index * 2)]).color]];
        view.index = (view.index + 1) % (data.count / 2);
        view.line2.text = ((Route *)[data objectAtIndex:(view.index * 2)]).name;
        view.minutes2.text = [YMGlobalHelper minutesFromString:[data objectAtIndex:(view.index * 2 + 1)]];
        view.eta2.text = [YMGlobalHelper dateStringFromString:[data objectAtIndex:(view.index * 2 + 1)]];
        view.dot1.alpha = 1;
        view.dot2.alpha = 0; 
        [view.dot2 redrawWithColor:[YMGlobalHelper colorFromHexString:((Route *)[data objectAtIndex:(view.index * 2)]).color]];
        
        view.eta1.alpha = 1;
        view.eta2.alpha = 0;
        view.eta1.frame = CGRectMake(28, 0, 50, 21);
        view.eta2.frame = CGRectMake(28, -10, 50, 21);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)settings:(id)sender
{
    self.slidingViewController.anchorLeftRevealAmount = 280.0f;
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end

//
//  YMVehicleAnnotation.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Vehicle;

@interface YMVehicleAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) Vehicle *vehicle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord vehicle:(Vehicle *)v title:(NSString *)t andSubtitle:(NSString *)st;
- (void)updateCoordinate:(CLLocationCoordinate2D)coord andVehicle:(Vehicle *)v;

@end

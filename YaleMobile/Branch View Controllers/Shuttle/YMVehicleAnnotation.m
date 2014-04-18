//
//  YMVehicleAnnotation.m
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMVehicleAnnotation.h"

@implementation YMVehicleAnnotation

@synthesize coordinate, title, subtitle, vehicle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord vehicle:(Vehicle *)v title:(NSString *)t andSubtitle:(NSString *)st
{
    self = [super init];
    if (self) {
        coordinate = coord;
        vehicle = v;
        title = t;
        subtitle = st;
    }
    return self;
}

- (void)updateCoordinate:(CLLocationCoordinate2D)coord andVehicle:(Vehicle *)v
{
    [self setCoordinate:coord];
    self.vehicle = v;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

@end

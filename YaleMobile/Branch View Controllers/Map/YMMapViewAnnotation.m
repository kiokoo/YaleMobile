//
//  YMMapViewAnnotation.m
//  YaleMobile
//
//  Created by Danqing on 4/10/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMMapViewAnnotation.h"
#import "Place.h"

@implementation YMMapViewAnnotation

- (YMMapViewAnnotation *)initWithPlace:(Place *)place;
{
    self = [super init];
    if (self != nil){
        _coordinate = CLLocationCoordinate2DMake([place.x doubleValue], [place.y doubleValue]);
        _title = place.name;
        _subtitle = place.address;
    }
    return self;
}

@end

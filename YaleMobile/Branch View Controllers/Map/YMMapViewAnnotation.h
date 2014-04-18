//
//  YMMapViewAnnotation.h
//  YaleMobile
//
//  Created by Danqing on 4/10/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

@class Place;

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YMMapViewAnnotation : NSObject <MKAnnotation>

- (YMMapViewAnnotation *)initWithPlace:(Place *)place;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

@end

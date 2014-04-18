//
//  YMStopAnnotation.h
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Stop;

@interface YMStopAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSArray *routes;
@property (nonatomic, strong) Stop *s;

- (id)initWithLocation:(CLLocationCoordinate2D)coord routes:(NSArray *)rs stop:(Stop *)stop title:(NSString *)t andSubtitle:(NSString *)st;

@end

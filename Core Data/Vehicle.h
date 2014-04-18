//
//  Vehicle.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route, Stop;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * vehicleid;
@property (nonatomic, retain) NSNumber * heading;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * arrivaltime;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) Stop *nextstop;

@end

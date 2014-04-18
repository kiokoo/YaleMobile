//
//  Route.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment, Stop, Vehicle;

@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * inactive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * routeid;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSSet *segments;
@property (nonatomic, retain) NSSet *stops;
@property (nonatomic, retain) NSSet *vehicles;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addSegmentsObject:(Segment *)value;
- (void)removeSegmentsObject:(Segment *)value;
- (void)addSegments:(NSSet *)values;
- (void)removeSegments:(NSSet *)values;

- (void)addStopsObject:(Stop *)value;
- (void)removeStopsObject:(Stop *)value;
- (void)addStops:(NSSet *)values;
- (void)removeStops:(NSSet *)values;

- (void)addVehiclesObject:(Vehicle *)value;
- (void)removeVehiclesObject:(Vehicle *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end

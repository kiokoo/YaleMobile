//
//  Stop.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route, Vehicle;

@interface Stop : NSManagedObject

@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stopid;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSSet *routes;
@property (nonatomic, retain) NSSet *vehicles;
@end

@interface Stop (CoreDataGeneratedAccessors)

- (void)addRoutesObject:(Route *)value;
- (void)removeRoutesObject:(Route *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;

- (void)addVehiclesObject:(Vehicle *)value;
- (void)removeVehiclesObject:(Vehicle *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end

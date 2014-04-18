//
//  Vehicle+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Vehicle.h"

@interface Vehicle (Initialize)

+ (void)vehicleWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeAllVehiclesInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeVehiclesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;

@end

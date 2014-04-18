//
//  Stop+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Stop.h"

@interface Stop (Initialize)

+ (void)stopWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Stop *)fetchStopWithId:(NSNumber *)stopId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeAllStopsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeStopsBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;

@end

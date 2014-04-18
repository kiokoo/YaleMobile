//
//  Route+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Route.h"

@interface Route (Initialize)

+ (void)routeWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeAllRoutesInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeRoutesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)getActiveRoutesInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Route *)fetchRouteWithId:(NSNumber *)routeId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllRoutesInManagedObjectContext:(NSManagedObjectContext *)context;

@end

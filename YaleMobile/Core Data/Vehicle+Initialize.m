//
//  Vehicle+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Vehicle+Initialize.h"
#import "Route+Initialize.h"
#import "Stop+Initialize.h"

@implementation Vehicle (Initialize)

+ (void)vehicleWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    if ([[data objectForKey:@"location"] isKindOfClass:[NSNull class]] || [[data objectForKey:@"tracking_status"] isEqualToString:@"down"]) return;
    
    Vehicle *vehicle = nil;
    
    NSInteger vehicleId = [[data objectForKey:@"vehicle_id"] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vehicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"vehicleid = %d", vehicleId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"vehicleid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) vehicle = [NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:context];
    else vehicle = [matches lastObject];
    
    vehicle.vehicleid = [NSNumber numberWithInteger:vehicleId];
    if (![[data objectForKey:@"heading"] isKindOfClass:[NSNull class]]) {
        vehicle.heading = [NSNumber numberWithInteger:[[data objectForKey:@"heading"] integerValue]];
    }
    vehicle.name = [data objectForKey:@"call_name"];
    vehicle.latitude = [[data objectForKey:@"location"] objectForKey:@"lat"];
    vehicle.longitude = [[data objectForKey:@"location"] objectForKey:@"lng"];
    vehicle.timestamp = [NSNumber numberWithDouble:timestamp];
    
    NSNumber *routeId = [NSNumber numberWithInteger:[[data objectForKey:@"route_id"] integerValue]];
    Route *route = [Route fetchRouteWithId:routeId inManagedObjectContext:context];
    if (route) vehicle.route = route;
    
    NSArray *ae = [data objectForKey:@"arrival_estimates"];
    if (ae && ae.count) {
        NSNumber *stopId = [NSNumber numberWithInteger:[[[ae objectAtIndex:0] objectForKey:@"stop_id"] integerValue]];
        Stop *stop = [Stop fetchStopWithId:stopId inManagedObjectContext:context];
        if (stop) {
            vehicle.nextstop = stop;
            vehicle.arrivaltime = [[ae objectAtIndex:0] objectForKey:@"arrival_at"];
        }
    }
    
    if (!vehicle.route) [context deleteObject:vehicle];
}

+ (void)removeAllVehiclesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Removing all vehicles.....");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vehicle"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"vehicleid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (Vehicle *v in matches) [context deleteObject:v];
}

+ (void)removeVehiclesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vehicle"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"vehicleid" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing vehicles with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Vehicle *v in matches) [context deleteObject:v];
}

@end

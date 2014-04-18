//
//  Route+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Route+Initialize.h"
#import "Segment+Initialize.h"

@implementation Route (Initialize)

+ (void)routeWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    if ([[data objectForKey:@"is_active"] integerValue] == 0) return;
    
    Route *route = nil;
    
    NSInteger routeId = [[data objectForKey:@"route_id"] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    request.predicate = [NSPredicate predicateWithFormat:@"routeid = %d", routeId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) route = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];
    else route = [matches lastObject];

    route.routeid = [NSNumber numberWithInteger:routeId];
    route.name = [data objectForKey:@"long_name"];
    route.color = [data objectForKey:@"color"];
    route.timestamp = [NSNumber numberWithDouble:timestamp];
    if (route.inactive.boolValue != YES) route.inactive = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_inactive", route.routeid]]) route.inactive = [NSNumber numberWithBool:YES];
    
    if (route.inactive.boolValue == NO) {
        NSArray *segments = [data objectForKey:@"segments"];
        NSMutableSet *segmentsSet = [[NSMutableSet alloc] initWithCapacity:segments.count];
        
        for (NSArray *s in segments) {
            BOOL isForward = ([[s objectAtIndex:1] isEqualToString:@"forward"]) ? YES : NO;
            Segment *segment = [Segment segmentWithId:[[s objectAtIndex:0] integerValue] andDirection:isForward forTimestamp:timestamp inManagedObjectContext:context];
            if (segment) [segmentsSet addObject:segment];
        }
        route.segments = segmentsSet;
    }
}

+ (Route *)fetchRouteWithId:(NSNumber *)routeId inManagedObjectContext:(NSManagedObjectContext *)context
{
    Route *route = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    request.predicate = [NSPredicate predicateWithFormat:@"routeid = %@", routeId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (matches.count == 1) route = [matches lastObject];
    return route;
}

+ (NSString *)getActiveRoutesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    request.predicate = [NSPredicate predicateWithFormat:@"inactive != %@", [NSNumber numberWithBool:YES]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || matches.count == 0) return nil;
    else {
        NSLog(@"Matches %d", matches.count);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:matches.count];
        for (Route *r in matches) [array addObject:r.routeid.stringValue];
        if (array.count == 0) return nil;
        return [NSString stringWithFormat:@"&routes=%@",[array componentsJoinedByString:@","]];
    }
}

+ (NSArray *)getAllRoutesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

+ (void)removeAllRoutesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Removing all routes.....");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (Route *route in matches) [context deleteObject:route];
}

+ (void)removeRoutesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing routes with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Route *route in matches) [context deleteObject:route];
}

@end

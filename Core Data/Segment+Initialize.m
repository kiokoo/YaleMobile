//
//  Segment+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Segment+Initialize.h"

@implementation Segment (Initialize)

+ (Segment *)segmentWithId:(NSInteger)segmentId andDirection:(BOOL)isForward forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    Segment *segment = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    request.predicate = [NSPredicate predicateWithFormat:@"segmentid = %d", segmentId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return nil;
    else if (matches.count == 0) segment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:context];
    else segment = [matches lastObject];
    
    segment.segmentid = [NSNumber numberWithInteger:segmentId];
    segment.timestamp = [NSNumber numberWithDouble:timestamp];
    
    // 1 - forward, 2 - backward, 3 - both
    if (segment.direction.integerValue == 3 || (segment.direction.integerValue == 1 && isForward == NO) || (segment.direction.integerValue == 2 && isForward == YES))
        segment.direction = [NSNumber numberWithInteger:3];
    else segment.direction = (isForward) ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:2];
    return segment;
}

+ (void)segmentWithID:(NSInteger)segmentId andEncodedString:(NSString *)string inManagedObjectContext:(NSManagedObjectContext *)context
{
    Segment *segment = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    request.predicate = [NSPredicate predicateWithFormat:@"segmentid = %d", segmentId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (matches.count == 1) segment = [matches lastObject];
    else return;
    segment.string = string;
}

+ (void)removeSegmentsBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing segments with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Segment *segment in matches) [context deleteObject:segment];
}

@end

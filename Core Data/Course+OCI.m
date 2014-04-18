//
//  Course+OCI.m
//  YaleMobile
//
//  Created by Danqing on 1/23/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Course+OCI.h"

@implementation Course (OCI)

+ (Course *)courseWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    Course *course = nil;
    
    course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    course.name = [data objectForKey:@"name"];
    course.data = [data objectForKey:@"data"];
    course.section = [data objectForKey:@"section"];
    course.srn = [data objectForKey:@"srn"];
    course.code = [NSString stringWithFormat:@"%@%@", [data objectForKey:@"subject"], [data objectForKey:@"number"]];
    course.instructor = [data objectForKey:@"instructor"];
    course.happens = [data objectForKey:@"happens"];
    course.timestamp = [NSNumber numberWithDouble:timestamp];
    
    return course;
}

+ (void)removeAllCoursesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Removing all courses.....");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (Course *course in matches) [context deleteObject:course];
}

+ (void)removeCoursesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Course *course in matches) [context deleteObject:course];
}

@end

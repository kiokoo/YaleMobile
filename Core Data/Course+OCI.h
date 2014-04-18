//
//  Course+OCI.h
//  YaleMobile
//
//  Created by Danqing on 1/23/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Course.h"

@interface Course (OCI)

+ (Course *)courseWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeAllCoursesInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeCoursesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;


@end

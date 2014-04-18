//
//  Segment+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Segment.h"

@interface Segment (Initialize)

+ (Segment *)segmentWithId:(NSInteger)segmentId andDirection:(BOOL)isForward forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)segmentWithID:(NSInteger)segmentId andEncodedString:(NSString *)string inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeSegmentsBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context;

@end

//
//  Place+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 1/31/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Place.h"

@interface Place (Initialize)

+ (void)initializeFromFile:(NSString *)file inManagedObjectContext:(NSManagedObjectContext *)context;

@end

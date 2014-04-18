//
//  Place+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 1/31/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Place+Initialize.h"
#import "Abbreviation+Initialize.h"

@implementation Place (Initialize)

+ (void)initializeFromFile:(NSString *)file inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *info in array) {
        [self initializePlaceWithInfo:info inManagedObjectContext:context];
    }
}

+ (void)initializePlaceWithInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [info objectForKey:@"Full name"]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
    else place = [matches lastObject];
    
    NSArray *abbrs = [[info objectForKey:@"Abbreviations"] componentsSeparatedByString:@","];
    NSMutableSet *abbrSet = [[NSMutableSet alloc] initWithCapacity:abbrs.count];
    for (NSString *abbr in abbrs) {
        Abbreviation *abbreviation = [Abbreviation buildAbbreviationWithString:abbr inManagedObjectContext:context];
        [abbrSet addObject:abbreviation];
    }
    
    place.abbrs = abbrSet;
    place.name = [info objectForKey:@"Full name"];
    place.address = [info objectForKey:@"Street Address"];
    
    NSArray *coord = [[info objectForKey:@"Coordinate"] componentsSeparatedByString:@","];
    place.x = [NSNumber numberWithDouble:[[coord objectAtIndex:0] doubleValue]];
    place.y = [NSNumber numberWithDouble:[[coord objectAtIndex:1] doubleValue]];
}

@end

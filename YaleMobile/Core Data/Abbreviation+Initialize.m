//
//  Abbreviation+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 4/3/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Abbreviation+Initialize.h"

@implementation Abbreviation (Initialize)

+ (Abbreviation *)buildAbbreviationWithString:(NSString *)string inManagedObjectContext:(NSManagedObjectContext *)context
{
    Abbreviation *abbreviation = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Abbreviation"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", string];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
        
    if (matches.count == 0) {
        abbreviation = [NSEntityDescription insertNewObjectForEntityForName:@"Abbreviation" inManagedObjectContext:context];
        abbreviation.name = string;
    } else if (matches.count == 1) {
        abbreviation = [matches lastObject];
    }
    
    return abbreviation;
}

@end

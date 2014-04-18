//
//  Office+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 1/31/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Office+Initialize.h"

@implementation Office (Initialize)

+ (void)initializeFromFile:(NSString *)file inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *array = [dic allKeys];
    
    for (NSDictionary *key in array) {
        NSDictionary *subDic = [dic objectForKey:key];
        NSArray *keys = [subDic allKeys];
        for (NSString *name in keys) [self initializeOfficeWithKey:name andInfo:[subDic objectForKey:name] inManagedObjectContext:context];
    }
}

+ (void)initializeOfficeWithKey:(NSString *)key andInfo:(NSString *)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    Office *office = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Office"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (phone = %@)", key, info];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) office = [NSEntityDescription insertNewObjectForEntityForName:@"Office" inManagedObjectContext:context];
    else office = [matches lastObject];
    
    office.name = key;
    office.phone = info;
}

- (NSString *)firstLetter
{
    [self willAccessValueForKey:@"firstLetter"];
    NSString *string = [[self valueForKey:@"name"] uppercaseString];
    NSString *firstLetter = [string substringToIndex:1];
    [self didAccessValueForKey:@"firstLetter"];
    return firstLetter;
}

@end

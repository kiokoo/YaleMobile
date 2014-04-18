//
//  Place.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Abbreviation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSSet *abbrs;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addAbbrsObject:(Abbreviation *)value;
- (void)removeAbbrsObject:(Abbreviation *)value;
- (void)addAbbrs:(NSSet *)values;
- (void)removeAbbrs:(NSSet *)values;

@end

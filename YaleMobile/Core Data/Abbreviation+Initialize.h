//
//  Abbreviation+Initialize.h
//  YaleMobile
//
//  Created by Danqing on 4/3/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Abbreviation.h"

@interface Abbreviation (Initialize)

+ (Abbreviation *)buildAbbreviationWithString:(NSString *)string inManagedObjectContext:(NSManagedObjectContext *)context;

@end

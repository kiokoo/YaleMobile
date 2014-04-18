//
//  Office.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Office : NSManagedObject

@property (nonatomic, retain) NSString * firstLetter;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;

@end

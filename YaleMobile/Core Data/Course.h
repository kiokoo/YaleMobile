//
//  Course.h
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * happens;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * srn;
@property (nonatomic, retain) NSNumber * timestamp;

@end

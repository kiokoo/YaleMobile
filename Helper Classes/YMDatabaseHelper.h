//
//  YMDatabaseHelper.h
//  YaleMobile
//
//  Created by Danqing on 1/31/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^completion_block_t)(UIManagedDocument *database);

@interface YMDatabaseHelper : NSObject

+ (void)openDatabase:(NSString *)database usingBlock:(completion_block_t)completionBlock;

+ (void)setManagedDocumentTo:(UIManagedDocument *)database;
+ (UIManagedDocument *)getManagedDocument;

@end

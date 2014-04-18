//
//  YMDatabaseHelper.m
//  YaleMobile
//
//  Created by Danqing on 1/31/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMDatabaseHelper.h"
#import "Place+Initialize.h"
#import "Office+Initialize.h"

static NSMutableDictionary *managedDocumentDictionary = nil;
static UIManagedDocument *globalDatabase = nil;

@implementation YMDatabaseHelper

+ (void)openDatabase:(NSString *)database usingBlock:(completion_block_t)completionBlock
{
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:database];
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:database];
    
    if (!document) {
        document = [[UIManagedDocument alloc] initWithFileURL:url];
        [managedDocumentDictionary setObject:document forKey:database];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSError *error = nil;
        NSURL *desturl = [url URLByAppendingPathComponent:@"StoreContent"];
        [[NSFileManager defaultManager] createDirectoryAtURL:desturl withIntermediateDirectories:YES attributes:nil error:&error];
        NSURL *finalurl = [desturl URLByAppendingPathComponent:@"persistentStore"];
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"persistentStore"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:finalurl.path error:&error];
        
        completionBlock(document);
        
        /*[document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self buildDatabase:document atURL:url];
            completionBlock(document);
        }];*/
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            completionBlock(document);
        }];
    } else if (document.documentState == UIDocumentStateNormal) {
        completionBlock(document);
    }
}

+ (void)buildDatabase:(UIManagedDocument *)document atURL:(NSURL *)url
{
    dispatch_queue_t buildQ = dispatch_queue_create("Build Database", NULL);
    dispatch_async(buildQ, ^{
        [document.managedObjectContext performBlock:^{
            [Office initializeFromFile:@"Phonebook" inManagedObjectContext:document.managedObjectContext];
            [Place initializeFromFile:@"Map" inManagedObjectContext:document.managedObjectContext];
        }];
    });
}

+ (void)setManagedDocumentTo:(UIManagedDocument *)database
{
    if (!globalDatabase) globalDatabase = database;
}

+ (UIManagedDocument *)getManagedDocument
{
    return globalDatabase;
}

@end

//
//  YMServerCommunicator.h
//  YaleMobile
//
//  Created by Danqing on 12/25/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^array_block_t)(NSArray *array);
typedef void (^triple_array_block_t)(NSArray *array1, NSArray *array2, NSArray *array3);
typedef void (^dict_block_t)(NSDictionary *dict);

@class AFHTTPClient;

@interface YMServerCommunicator : NSObject

+ (AFHTTPClient *)getHTTPClient;
+ (void)cancelAllHTTPRequests;
+ (BOOL)isCanceled;
+ (void)resetCanceled;

// YaleMobile 2.x JSON APIs - not yet 2.0

+ (NSArray *)getLocationFromName:(NSString *)name;
+ (void)getGlobalSpecialInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getAllDiningStatusForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getDiningDetailForLocation:(NSUInteger)locationID forController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getDiningSpecialInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getAllLaundryStatusForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getLaundryStatusForLocation:(NSString *)code forController:(UIViewController *)controller usingBlock:(triple_array_block_t)completionBlock;
+ (void)getWeatherForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getRouteInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getStopInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;
+ (void)getSegmentInfoForController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(dict_block_t)completionBlock;
+ (void)getShuttleInfoForController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(array_block_t)completionBlock;
+ (void)getArrivalEstimateForStop:(NSString *)stop forController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(array_block_t)completionBlock;

+ (void)getLibraryHoursForLocation:(NSString *)location controller:(UIViewController *)controller usingBlock:(array_block_t)completionBlock;

// YaleMobile 1.x HTML Parsing APIs (to be deprecated)

+ (NSMutableDictionary *)getInformationForPerson:(NSString *)responseString;
+ (NSArray *)getPeopleList:(NSString *)responseString;

@end

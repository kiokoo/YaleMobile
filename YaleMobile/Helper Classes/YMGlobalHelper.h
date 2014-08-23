//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMSubtitleCell.h"
#import "YMSimpleCell.h"


@interface YMGlobalHelper : NSObject

/*
 Determines current time, for UI and message changes.
 Return value:
  1 | 6 a.m. to 12 p.m. -> day, morning
  2 | 12 p.m. to 6 p.m. -> day, afternoon
  3 | 6 p.m. to 10 a.m. -> day, evening
  4 | 10 p.m. to 6 a.m. -> day, night
 */
+ (NSInteger)getCurrentTime;

+ (void)setupUserDefaults;
+ (void)setupSlidingViewControllerForController:(UIViewController *)viewController;
+ (void)setupMenuButtonForController:(UIViewController *)viewController;
+ (void)addMenuButtonToController:(UIViewController *)viewController;
+ (NSString *)buildBluebookFilters;
+ (NSString *)getTermForBluebookRequest;

+ (NSTimeInterval)getTimestamp;
+ (NSString *)dateStringFromString:(NSString *)string;
+ (NSString *)minutesFromString:(NSString *)string;

+ (UIColor *)colorFromHexString:(NSString *)string;

+ (NSString *)getIconNameForWeather:(NSInteger)code;
+ (NSString *)getBgNameForWeather:(NSInteger)code;

+ (CGSize)boundText:(NSString *)text withFont:(UIFont *)font andConstraintSize:(CGSize)size;

+ (void)showNotificationInViewController:(UIViewController *)vc
                                 message:(NSString *)msg
                               tintColor:(UIColor *)color;
+ (void)hideNotificationView;

@end

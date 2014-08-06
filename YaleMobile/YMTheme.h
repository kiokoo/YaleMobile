//
//  YMTheme.h
//  YaleMobile
//
//  Created by Danqing on 7/29/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTheme : NSObject

+ (UIColor *)blue;

+ (UIColor *)grey;

+ (UIColor *)lightGrey;

/** Used in dining view */
+ (UIColor *)greenishBlue;

/** Used in laundry detail view, and bluebook subject view */
+ (UIColor *)reddishOrange;

/** Used in bluebook filter view */
+ (UIColor *)brightYellow;

/** Used in bluebook subject view */
+ (UIColor *)lightBlue;

/** Used in bluebook filter view and hours library view and dining detail view */
+ (UIColor *)white;

+ (UIColor *)notificationWarningTintColor;

+ (UIColor *)notificationErrorTintColor;

+ (UIColor *)notificationSuccessTintColor;

+ (UIColor *)notificationTintColor;

@end

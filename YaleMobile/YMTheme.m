//
//  YMTheme.m
//  YaleMobile
//
//  Created by Danqing on 7/29/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMTheme.h"

#define RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation YMTheme

+ (UIColor *)blue { return [UIColor colorWithRed:0.05 green:0.3 blue:0.57 alpha:1]; }

+ (UIColor *)gray { return RGB(110, 115, 115); }

+ (UIColor *)lightGray { return [UIColor lightGrayColor]; }

+ (UIColor *)separatorGray { return RGB(245, 245, 245); }

/** Used in dining view */
+ (UIColor *)diningSpecialTextColor { return RGB(84, 146, 173); }

/** Used in laundry detail view, and bluebook subject view */
+ (UIColor *)laundryTimeAndBluebookHappensTextColor { return RGB(253, 97, 77); }

/** Used in bluebook filter view */
+ (UIColor *)bluebookFilterSecondaryTextColor { return RGB(255, 224, 91); }

/** Used in bluebook subject view */
+ (UIColor *)bluebookSubjectCodeTextColor { return RGB(120, 168, 193); }

/** Used in bluebook filter view and hours library view and dining detail view */
+ (UIColor *)white { return [UIColor whiteColor]; }

+ (UIColor *)notificationErrorTintColor
{
  return [[UIColor redColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)notificationSuccessTintColor
{
  return [[UIColor greenColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)notificationWarningTintColor
{
  return [[self laundryTimeAndBluebookHappensTextColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)notificationTintColor
{
  return [[self blue] colorWithAlphaComponent:0.5];
}

@end

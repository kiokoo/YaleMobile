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

+ (UIColor *)mainViewTemperatureLabelColor
{
  return RGB(111, 113, 121);
}

/* Migrated from UIColor+YaleMobile */
+ (UIColor *)YMOrange
{
  return [UIColor colorWithRed:236/255.0 green:77/255.0 blue:34/255.0 alpha:1];
}

+ (UIColor *)YMLightOrange
{
  return [UIColor colorWithRed:245/255.0 green:164/255.0 blue:141/255.0 alpha:1];
}

+ (UIColor *)YMBluebookOrange
{
  return [UIColor colorWithRed:253/255.0 green:97/255.0 blue:77/255.0 alpha:1];
}

+ (UIColor *)YMBlue
{
  return [UIColor colorWithRed:72/255.0 green:193/255.0 blue:213/255.0 alpha:1];
}

+ (UIColor *)YMLightBlue
{
  return [UIColor colorWithRed:161/255.0 green:223/255.0 blue:223/255.0 alpha:1];
}

+ (UIColor *)YMTeal
{
  return [UIColor colorWithRed:111/255.0 green:132/255.0 blue:132/255.0 alpha:1];
}

+ (UIColor *)YMLightTeal
{
  return [UIColor colorWithRed:181/255.0 green:192/255.0 blue:192/255.0 alpha:1];
}

+ (UIColor *)YMRed
{
  return [UIColor redColor];
}

+ (UIColor *)YMBluebookBlue
{
  return [UIColor colorWithRed:120/255.0 green:168/255.0 blue:193/255.0 alpha:1];
}

+ (UIColor *)YMGreen
{
  return [UIColor colorWithRed:0/255.0 green:166/255.0 blue:81/255.0 alpha:1];
}

+ (UIColor *)YMLaundryOrange
{
  return [UIColor colorWithRed:247/255.0 green:148/255.0 blue:29/255.0 alpha:1];
}

+ (UIColor *)YMDiningBlue
{
  return [UIColor colorWithRed:84/255.0 green:146/255.0 blue:173/255.0 alpha:1];
}

+ (UIColor *)YMDiningRed
{
  return [UIColor colorWithRed:218/255.0 green:46/255.0 blue:69/255.0 alpha:1];
}

+ (UIColor *)YMDiningGreen
{
  return [UIColor colorWithRed:72/255.0 green:173/255.0 blue:58/255.0 alpha:1];
}

@end

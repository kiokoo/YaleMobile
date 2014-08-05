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

+ (UIColor *)grey { return RGB(111, 132, 132); }

+ (UIColor *)lightGrey { return [UIColor lightGrayColor]; }

/** Used in dining view */
+ (UIColor *)greenishBlue { return RGB(84, 146, 173); }

/** Used in laundry detail view, and bluebook subject view */
+ (UIColor *)reddishOrange { return RGB(253, 97, 77); }

/** Used in bluebook filter view */
+ (UIColor *)brightYellow { return RGB(255, 224, 91); }

/** Used in bluebook subject view */
+ (UIColor *)lightBlue { return RGB(120, 168, 193); }

/** Used in bluebook filter view and hours library view and dining detail view */
+ (UIColor *)white { return [UIColor whiteColor]; }

@end

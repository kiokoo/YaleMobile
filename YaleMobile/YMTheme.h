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

+ (UIColor *)gray;

+ (UIColor *)lightGray;

+ (UIColor *)separatorGray;

+ (UIColor *)diningSpecialTextColor;

+ (UIColor *)laundryTimeAndBluebookHappensTextColor;

+ (UIColor *)bluebookFilterSecondaryTextColor;

+ (UIColor *)bluebookSubjectCodeTextColor;

+ (UIColor *)white;

+ (UIColor *)notificationWarningTintColor;

+ (UIColor *)notificationErrorTintColor;

+ (UIColor *)notificationSuccessTintColor;

+ (UIColor *)notificationTintColor;

+ (UIColor *)mainViewTemperatureLabelColor;

+ (UIColor *)cellHighlightBackgroundViewColor;

+ (UIColor *)socialScienceColor;

+ (UIColor *)scienceColor;

+ (UIColor *)humanitiesColor;

+ (UIColor *)writingColor;

+ (UIColor *)quantitativeReasoningrColor;

+ (UIColor *)languageColor;

/**
 *  This is the ligher grey, the background color of
 *  searchBar.
 */
+ (UIColor *)searchBarBarTintColor;

/**
 *  This is the darker one, the color of the cancel
 *  button and text. Similar to tintColor of a UIView.
 */
+ (UIColor *)searchbarTintColor;

/* Migrated from UIColor+YaleMobile */
+ (UIColor *)YMOrange;
+ (UIColor *)YMLightOrange;
+ (UIColor *)YMBlue;
+ (UIColor *)YMLightBlue;
+ (UIColor *)YMTeal;
+ (UIColor *)YMLightTeal;
+ (UIColor *)YMBluebookOrange;
+ (UIColor *)YMRed;
+ (UIColor *)YMGreen;
+ (UIColor *)YMBluebookBlue;
+ (UIColor *)YMLaundryOrange;
+ (UIColor *)YMDiningBlue;
+ (UIColor *)YMDiningRed;
+ (UIColor *)YMDiningGreen;

@end

//
//  YMGlobalHelper.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YMGlobalHelper.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation YMGlobalHelper

+ (NSInteger)getCurrentTime
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSInteger hour = [components hour];
    
    if (hour >= 6 && hour < 12) return 1;
    else if (hour >= 12 && hour < 18) return 2;
    else if (hour >= 18 && hour < 22) return 3;
    else return 4;
}

+ (void)setupUserDefaults
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Initialized"]) {
        // bluebook defaults
        [[NSUserDefaults standardUserDefaults] setObject:@"Fall 2013" forKey:@"Bluebook Term"];
        [[NSUserDefaults standardUserDefaults] setObject:@"ALL" forKey:@"Bluebook Category"];
        [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:@"Bluebook Language"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Initialized"];
    }
}

+ (void)setupSlidingViewControllerForController:(UIViewController *)viewController
{
    if (![viewController.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        viewController.slidingViewController.underLeftViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    viewController.slidingViewController.anchorLeftRevealAmount = 0;
    
    // Slide view gesture recognizer setup
    [viewController.navigationController.view addGestureRecognizer:viewController.slidingViewController.panGesture];
    [viewController.slidingViewController.panGesture setDelegate:(id<UIGestureRecognizerDelegate>)viewController];
    [viewController.slidingViewController setAnchorRightRevealAmount:280.0f];
    
    // Slide view shadow setup
    viewController.navigationController.view.layer.shadowOpacity = 0.75f;
    viewController.navigationController.view.layer.shadowRadius = 10.0f;
    viewController.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

+ (void)setupRightSlidingViewControllerForController:(UIViewController *)topController withRightController:(Class)class named:(NSString *)identifier
{
    if (![topController.slidingViewController.underRightViewController isKindOfClass:class]) {
        topController.slidingViewController.underRightViewController = [topController.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    [topController.slidingViewController setAnchorLeftRevealAmount:280.0f];
}

+ (void)setupMenuButtonForController:(UIViewController *)viewController
{
    viewController.slidingViewController.anchorRightRevealAmount = 280.0f;
    [viewController.slidingViewController anchorTopViewTo:ECRight];
}

+ (void)addMenuButtonToController:(UIViewController *)viewController
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 30, 22)];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [button addTarget:viewController action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [viewController.navigationItem setLeftBarButtonItem:barButtonItem];
}

+ (void)addBackButtonToController:(UIViewController *)viewController
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 19)];
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:viewController action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [viewController.navigationItem setLeftBarButtonItem:barButtonItem];
}

+ (NSString *)buildBluebookFilters
{
    // term
    NSString *term = [YMGlobalHelper getTerm];
    
    // category
    NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bluebook Category"];
    category = [category stringByPaddingToLength:1 withString:@" " startingAtIndex:0];
    
    // filters
    NSMutableArray *filters = [[NSMutableArray alloc] initWithCapacity:6];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluebook Humanities"]) [filters addObject:@"HU"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluebook Sciences"]) [filters addObject:@"SC"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluebook Social Sciences"]) [filters addObject:@"SO"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluebook Writing"]) [filters addObject:@"WR"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluebook Quantitative Reasoning"]) [filters addObject:@"QR"];
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bluebook Language"];
    if (![language isEqualToString:@"None"]) {
        language = [language stringByReplacingOccurrencesOfString:@"evel " withString:@""];
        [filters addObject:language];
    }
    
    // build string
    NSString *string = [NSString stringWithFormat:@"?term=%@&GUPgroup=%@", term, category];
    for (NSString *s in filters) string = [string stringByAppendingFormat:@"&distributionalgroup=%@", s];
    string = [string stringByAppendingString:@"&distributionGroupOperator=AND"];
    
    return string;
}

+ (NSString *)getTerm
{
    NSString *term = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bluebook Term"];
    term = [[[term stringByReplacingOccurrencesOfString:@"Fall" withString:@"03"]
             stringByReplacingOccurrencesOfString:@"Spring" withString:@"01"]
            stringByReplacingOccurrencesOfString:@"Summer" withString:@"02"];
    NSArray *comp = [term componentsSeparatedByString:@" "];
    term = [NSString stringWithFormat:@"%@%@", [comp objectAtIndex:1], [comp objectAtIndex:0]];
    return term;
}

+ (UIColor *)colorFromHexString:(NSString *)string
{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&result];
    return UIColorFromRGB(result);
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSDate *date = [dateFormatter dateFromString:[dateString stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(dateString.length - 5, 5)]];
    return date;
}

+ (NSString *)dateStringFromString:(NSString *)string
{
    if ([string isEqualToString:@"--"]) return @"--:--";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:[YMGlobalHelper dateFromString:string]];
    return dateString;
}

+ (NSString *)minutesFromString:(NSString *)string
{
    if ([string isEqualToString:@"--"]) return string;
    NSDate *date = [YMGlobalHelper dateFromString:string];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSMinuteCalendarUnit fromDate:[NSDate date] toDate:date options:0];
    return [NSString stringWithFormat:@"%i", components.minute];
}

/*
+ (void)addEtchToSubtitleCell:(UITableViewCell *)cell
{
    ((YMSubtitleCell *)cell).primary.shadowColor = [UIColor whiteColor];
    ((YMSubtitleCell *)cell).primary.shadowOffset = CGSizeMake(0, 1);
    ((YMSubtitleCell *)cell).secondary.shadowColor = [UIColor whiteColor];
    ((YMSubtitleCell *)cell).secondary.shadowOffset = CGSizeMake(0, 1);
}

+ (void)addEtchToSimpleCell:(UITableViewCell *)cell
{
    ((YMSimpleCell *)cell).name.shadowColor = [UIColor whiteColor];
    ((YMSimpleCell *)cell).name.shadowOffset = CGSizeMake(0, 1);
}
 */

+ (NSTimeInterval)getTimestamp
{
    NSDate *today = [NSDate date];
    return [today timeIntervalSince1970];
}

+ (NSString *)getIconNameForWeather:(NSInteger)code
{
    if (code == 21)
        return @"weather_sfog.png";
    else if (code == 32 || code == 36)
        return @"weather_sunny.png";
    else if (code == 22)
        return @"weather_haze.png";
    else if (code == 23 || code == 24)
        return @"weather_wind.png";
    else if (code == 20 || code == 19)
        return @"weather_fog.png";
    else if (code == 34)
        return @"weather_scloud.png";
    else if (code == 30 || code == 29)
        return @"weather_bcloud.png";
    else if (code == 26 || code == 27 || code == 28)
        return @"weather_vcloud.png";
    else if (code == 8 || code == 9 || code == 10)
        return @"weather_srain.png";
    else if (code == 11 || code == 12 || code == 40)
        return @"weather_brain.png";
    else if (code == 13 || code == 14 || code == 16 || code == 42 || code == 46)
        return @"weather_ssnow.png";
    else if (code == 15 || code == 43 || code == 41)
        return @"weather_bsnow.png";
    else if (code == 1 || code == 4 || code == 45)
        return @"weather_bstorm.png";
    else if (code == 5 || code == 6 || code == 7 || code == 17 || code == 18)
        return @"weather_sleet.png";
    else if (code == 37 || code == 38 || code == 39 || code == 47)
        return @"weather_thunder.png";
    else if (code == 33)
        return @"weather_cloudnight.png";
    else if (code == 31)
        return @"weather_clearnight.png";
    else
        return @"weather_na.png";
}

+ (NSString *)getBgNameForWeather:(NSInteger)code
{
    if (code == 8 || code == 9 || code == 10 || code == 11 || code == 12 || code == 40 || code == 5 || code == 6 || code == 7 || code == 17 || code == 18 || code == 37 || code == 38 || code == 39 || code == 47 || code == 1 || code == 4 || code == 45)
        return @"bg_rain.png";
    else if (code == 13 || code == 14 || code == 16 || code == 42 || code == 46 || code == 15 || code == 43 || code == 41)
        return @"bg_snow.png";
    else if (code == 20 || code == 19 || code == 22 || code == 21)
        return @"bg_fog.png";
    else if (code == 30 || code == 26 || code == 28 || code == 34 || code == 29 || code == 27)
        return @"bg_cloud.png";
    else return NULL;
}


@end

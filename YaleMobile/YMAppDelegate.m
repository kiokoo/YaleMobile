//
//  YMAppDelegate.m
//  YaleMobile
//
//  Created by Danqing on 3/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMAppDelegate.h"
#import "YMDatabaseHelper.h"
#import "YMGlobalHelper.h"
#import "YMTheme.h"
#import "UIImage+ImageWithColor.h"
#import <SWRevealViewController/SWRevealViewController.h>

#import <FlexManager.h>

@implementation YMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Just Launched"];
  [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {}];
  
  [[UINavigationBar appearance]
   setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0], NSFontAttributeName, nil]];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setBarTintColor:[YMTheme blue]];
  [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

#ifdef DEBUG
  [[FLEXManager sharedManager] showExplorer];
#endif
  
  // This is iOS8 only.
  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound
                                                                                  categories:nil]];
  }
  
  SWRevealViewController *revealVC = (SWRevealViewController *)self.window.rootViewController;
  UIStoryboard *storyboard;
  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  [revealVC pushFrontViewController:[storyboard instantiateViewControllerWithIdentifier:@"Home Root"] animated:NO];
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [[NSUserDefaults standardUserDefaults] setObject:deviceToken
                                            forKey:@"PushNotificationToken"];
  DLog(@"deviceToken: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  DLog(@"Failed to register for push notification. Error: %@", error.localizedDescription);
}
@end

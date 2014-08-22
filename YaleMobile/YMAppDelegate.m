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
#import <UIViewController+ECSlidingViewController.h>

#import <FlexManager.h>

@implementation YMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Just Launched"];
  [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {}];
  
  ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
  UIStoryboard *storyboard;
  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  slidingViewController.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Home Root"];
  
  [[UINavigationBar appearance]
   setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0], NSFontAttributeName, nil]];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setBarTintColor:[YMTheme blue]];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

#ifdef DEBUG
  [[FLEXManager sharedManager] showExplorer];
#endif
  
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

@end

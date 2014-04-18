//
//  YMAppDelegate.m
//  YaleMobile
//
//  Created by Danqing on 3/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMAppDelegate.h"
#import <ECSlidingViewController.h>
#import "YMDatabaseHelper.h"
#import "YMGlobalHelper.h"

@implementation YMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Just Launched"];
  [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {}];
  
  ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
  UIStoryboard *storyboard;
  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  slidingViewController.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Home Root"];
  
  /* Deprecated code, but kept as reference.
   * If the new code does not work properly below, check this to preserve the original effect
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                        [UIFont fontWithName:@"Helvetica" size:19.0], UITextAttributeFont,
                                                        [UIColor colorWithRed:7.0/255.0 green:80.0/255.0 blue:140.0/255.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset, nil]];
   */
  
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:7.0/255.0 green:80.0/255.0 blue:140.0/255.0 alpha:0.8];
  shadow.shadowOffset = CGSizeMake(0, 1);
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                        [UIFont fontWithName:@"Helvetica" size:19.0], NSFontAttributeName,
                                                        shadow, NSShadowAttributeName, nil]];

  
  [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"nav.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 0)] forBarMetrics:UIBarMetricsDefault];
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

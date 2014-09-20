//
//  YMAppDelegate.h
//  YaleMobile
//
//  Created by Danqing on 3/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import <MapKit/MapKit.h>

@interface YMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow          *window;
@property (strong, nonatomic) JGProgressHUD     *sharedNotificationView;
@property (strong, nonatomic, readonly) CLLocationManager *sharedLocationManager;

@end

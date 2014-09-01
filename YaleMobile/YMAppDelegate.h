//
//  YMAppDelegate.h
//  YaleMobile
//
//  Created by Danqing on 3/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CSNotificationView/CSNotificationView.h>

@interface YMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CSNotificationView *sharedNotificationView;

@end

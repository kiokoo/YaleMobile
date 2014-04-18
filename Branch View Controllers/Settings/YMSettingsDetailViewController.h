//
//  YMSettingsDetailViewController.h
//  YaleMobile
//
//  Created by Danqing on 5/13/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSettingsDetailViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *aboutHeader;
@property (nonatomic, strong) NSArray *aboutArray;
@property (nonatomic, strong) NSArray *creditHeader;
@property (nonatomic, strong) NSArray *creditArray;

@property (nonatomic) BOOL isAbout;

@end

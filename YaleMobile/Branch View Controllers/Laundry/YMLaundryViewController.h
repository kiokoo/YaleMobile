//
//  YMLaundryViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLaundryViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *url;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

//
//  YMHoursListViewController.h
//  YaleMobile
//
//  Created by Danqing on 5/17/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMHoursListViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

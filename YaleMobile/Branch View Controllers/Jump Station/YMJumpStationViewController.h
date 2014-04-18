//
//  YMJumpStationViewController.h
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMJumpStationViewController : UITableViewController

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *data;

@end

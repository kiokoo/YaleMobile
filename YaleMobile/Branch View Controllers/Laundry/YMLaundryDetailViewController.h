//
//  YMLaundryDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLaundryDetailViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *washers;
@property (nonatomic, strong) NSArray *dryers;
@property (nonatomic, strong) NSArray *machineStatuses;
@property (nonatomic, strong) NSString *roomCode;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

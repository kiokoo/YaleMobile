//
//  YMDiningViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDiningViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSDictionary *locations;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *special;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

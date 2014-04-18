//
//  YMHoursViewController.h
//  YaleMobile
//
//  Created by Danqing on 1/30/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMHoursViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSDictionary *detailData;
@property (nonatomic, strong) NSString *detailTitle;

@end

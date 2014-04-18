//
//  YMCalendarViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/25/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCalendarViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *schools;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

//
//  YMBluebookDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

@class Course;

#import <UIKit/UIKit.h>

@interface YMBluebookDetailViewController : UITableViewController

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) NSMutableDictionary *data;

- (void)parseData;

@end

//
//  YMAcademicCalendarDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

/*
 0 Endpoints		GRAY
 1 Holidays         GREEN
 2 Classes begin	ORANGE
 3 Classes end		GREEN-BLUE
 4 Exams begin		YELLOW
 5 Exams end		BLUE-PURPLE
 6 Dorm closes		PURPLE
 7 Important		RED
 8 Commencement     BLUE
 */

#import <UIKit/UIKit.h>

@interface YMAcademicCalendarDetailViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *calendar;
@property (nonatomic, strong) NSArray *terms;
@property (nonatomic, strong) NSArray *sorted;

@end

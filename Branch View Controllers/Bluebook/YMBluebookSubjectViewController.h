//
//  YMBluebookSubjectViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface YMBluebookSubjectViewController : CoreDataTableViewController

@property (nonatomic, strong) NSString *raw;
@property (nonatomic, strong) UIManagedDocument *db;
@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)useDocument;

@end

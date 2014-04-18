//
//  YMDiningDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDiningDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *abbr;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic) NSInteger locationID;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSString *special;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *overlay;

@end

//
//  YMHoursLibraryViewController.h
//  YaleMobile
//
//  Created by Danqing on 6/22/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface YMHoursLibraryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImageView *overlay;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *phoneURL;

@end

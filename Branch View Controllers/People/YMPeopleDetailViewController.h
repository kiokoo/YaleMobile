//
//  YMPeopleDetailViewController.h
//  YaleMobile
//
//  Created by Danqing on 1/5/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface YMPeopleDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSString *phoneURL;

@end

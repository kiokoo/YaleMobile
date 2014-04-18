//
//  YMSettingsViewController.h
//  YaleMobile
//
//  Created by iBlue on 12/27/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface YMSettingsViewController : UITableViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) NSArray *abouts;
@property (nonatomic) BOOL isAbout;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

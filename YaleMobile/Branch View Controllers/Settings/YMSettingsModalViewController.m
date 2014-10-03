//
//  YMSettingsModalViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMSettingsModalViewController.h"
#import "YMTheme.h"
#import "YMGlobalHelper.h"
#import "YMMainViewController.h"
#import "YMAppDelegate.h"
#import <PureLayout/PureLayout.h>

@interface YMSettingsModalViewController () <UITableViewDataSource>
/**
 *  The text displayed above the name textfield.
 */
@property (nonatomic, strong) NSString *welcomeText;
@end

@implementation YMSettingsModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.welcomeText = @"Hey there! Thank you for using YaleMobile. What would you like me to call you?";
  
  UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  
  [confirm setBackgroundImage:[UIImage imageNamed:@"button_navbar_ok.png"]
                     forState:UIControlStateNormal];
  [self.navigationItem
      setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:confirm]];
  
  [confirm addTarget:self
              action:@selector(confirm:)
    forControlEvents:UIControlEventTouchUpInside];

  UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  [cancel setBackgroundImage:[UIImage imageNamed:@"button_navbar_cancel.png"]
                    forState:UIControlStateNormal];
  
  [self.navigationItem
      setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancel]];
  
  [cancel addTarget:self
             action:@selector(cancel:)
   forControlEvents:UIControlEventTouchUpInside];

  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  [self.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
  
  self.tableView.dataSource     = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [YMTheme separatorGray];
  
  self.textField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
  self.textField1.textColor       = [YMTheme lightGray];
  self.textField1.font            = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
  self.textField1.backgroundColor = [UIColor clearColor];
  self.textField1.tintColor       = [YMTheme searchbarTintColor];
  self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSString *name       = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
  self.textField1.text = (name) ? (name) : (@"");
  
  [self.textField1 becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self dismissKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  // This is iOS8 only.
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:
     [UIUserNotificationSettings
      settingsForTypes:UIUserNotificationTypeAlert |
      UIUserNotificationTypeBadge |
      UIUserNotificationTypeSound
      categories:nil]];
    
    [[(YMAppDelegate *)[UIApplication sharedApplication].delegate sharedLocationManager] requestWhenInUseAuthorization];
  }
}

- (void)dismissKeyboard
{
  [self.textField1 resignFirstResponder];
}

- (void)confirm:(id)sender
{
  if (self.textField1.text.length) {
    [[NSUserDefaults standardUserDefaults] setObject:self.textField1.text forKey:@"Name"];
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Name"];
  }
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.selectionStyle  = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), height)];
  
  UILabel *label = [UILabel newAutoLayoutView];
  [headerView addSubview:label];
  [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
  [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
  [label autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
  [label autoSetDimension:ALDimensionHeight toSize:height-30];
  
  label.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
  label.textColor = [YMTheme gray];
  label.text = self.welcomeText;
  label.numberOfLines = 0;
  label.lineBreakMode = NSLineBreakByWordWrapping;
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGSize size = [YMGlobalHelper boundText:self.welcomeText
                                 withFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]
                        andConstraintSize:CGSizeMake(self.view.bounds.size.width - 40, 99999.0)];
  return size.height+30;
}

@end

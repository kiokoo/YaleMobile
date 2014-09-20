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
#warning TODO(hengchu): this may need to be removed.
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  self.background1.image = [[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  self.background1.alpha = 0.6;

  
  NSString *name       = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
  self.textField1.text = (name) ? (name) : (@"");
  
  [self.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
  
  self.tableView.dataSource     = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.scrollEnabled  = NO;
  
  self.textField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
  self.textField1.textColor       = [YMTheme lightGray];
  self.textField1.font            = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
  self.textField1.backgroundColor = [UIColor clearColor];
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
  cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat width = CGRectGetWidth(self.textField1.bounds);
  CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), height)];
  
  UILabel *label = [UILabel newAutoLayoutView];
  [headerView addSubview:label];
  [label autoAlignAxis:ALAxisHorizontal toSameAxisOfView:label.superview withOffset:5];
  [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
  [label autoSetDimensionsToSize:CGSizeMake(width, height)];
  
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
                        andConstraintSize:CGSizeMake(self.textField1.bounds.size.width, 99999.0)];
  return size.height + 15;
}

@end

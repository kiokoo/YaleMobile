//
//  YMLaundryViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YMLaundryViewController.h"
#import "YMLaundryDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"
#import "YMLaundryCell.h"
#import "YMSimpleCell.h"

#import "YMTheme.h"

#define RECENT_LAUNDRY_URL @"Key for storing recent laundry url"

#define SELECT_LOCATION_INDEX (2) //previously 0. This is the row index of the Select Location title cell
#define FIRST_CELL_INDEX (3) //previously 1. This is the row index of the first cell in the list of locations
#define RECENT_TITLE_INDEX (0) // row index of Recent title cell
#define RECENT_CELL_INDEX (1) //row index of Recent laundry room cell
#define NUM_EXTRA_ROWS (3) // number of rows above the main list of locations. Previously was 1. Includes 1 for Select Location and 1 for Recent and 1 For the Recently selected laundroom
#define LAST_CELL_INDEX (self.locations.count+NUM_EXTRA_ROWS-1) //index of last cell

@interface YMLaundryViewController ()

@end

@implementation YMLaundryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Laundry";
  
  [YMGlobalHelper addMenuButtonToController:self];
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Laundry" ofType:@"plist"];
  self.locations = [[NSArray alloc] initWithContentsOfFile:path]; //array of strings - names of locations
  NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Laundry URL" ofType:@"plist"];
  self.url = [[NSArray alloc] initWithContentsOfFile:path2]; // array of numbers.
  self.data = nil;
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  
  self.refreshControl.layer.zPosition += 1;
  
  [self.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
}

- (void)displayRecent:(UIView *)button
{
  id url = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_LAUNDRY_URL];
  if (url) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.url indexOfObject:url]+NUM_EXTRA_ROWS inSection:0];
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Laundry Segue" sender:self];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  
  [super viewWillAppear:animated];
  
  [YMServerCommunicator cancelAllHTTPRequests];
  
  [YMGlobalHelper setupSlidingViewControllerForController:self];
  if (self.selectedIndexPath) {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = nil;
  }
  //When the view returns from having tapped on a location, the Recent Laundroom may have changed. Update that specific cell.
  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RECENT_CELL_INDEX inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (self.data == nil) {
    [self refresh];
    [YMGlobalHelper showNotificationInViewController:self
                                             message:@"Loading"
                                               style:JGProgressHUDStyleLight];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  UIView *cell = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
  if (fabsf(translation.x) > fabsf(translation.y)) return YES;
  return NO;
}

- (void)menu:(id)sender
{
  [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)refresh
{
  [YMServerCommunicator getAllLaundryStatusForController:self usingBlock:^(NSArray *data) {
    self.data = data;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [YMGlobalHelper hideNotificationView];
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  YMLaundryDetailViewController *ldvc = (YMLaundryDetailViewController *)[segue destinationViewController];
  //NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
  NSIndexPath *selected = self.selectedIndexPath;
  ldvc.roomCode = [self.url objectAtIndex:selected.row - NUM_EXTRA_ROWS];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.locations.count + NUM_EXTRA_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == SELECT_LOCATION_INDEX || indexPath.row == RECENT_TITLE_INDEX) {
    YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Header"];
    cell.name1.textColor = [YMTheme gray];
    cell.name1.text = indexPath.row==RECENT_TITLE_INDEX ? @"Recent room" : @"Select a location";
    return cell;
  } else {
    YMLaundryCell *cell;
    cell = (indexPath.row == FIRST_CELL_INDEX) ? (YMLaundryCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Cell Top"] : (YMLaundryCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Cell Middle"];
    
    NSInteger index = indexPath.row - NUM_EXTRA_ROWS;
    if (indexPath.row==RECENT_CELL_INDEX) {
      id url = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_LAUNDRY_URL];
      if (url) {
        index = [self.url indexOfObject:url];
      } else {
        //no data will go here, so set the cell up with dummy information.
        cell.location1.text = @"Recent Location will appear here";
        cell.userInteractionEnabled = NO;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_topbottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.backgroundView.alpha = 0.6;
        cell.location1.textColor = [YMTheme gray];
        return cell;
      }
    }
    cell.location1.text = [self.locations objectAtIndex:index];
    
    if (self.data) {
      NSString *washerCount = [[self.data objectAtIndex:index] objectAtIndex:0];
      NSString *dryerCount = [[self.data objectAtIndex:index] objectAtIndex:1];
      cell.washer1.text = [NSString stringWithFormat:@"Washers: %@", washerCount];
      cell.dryer1.text = [NSString stringWithFormat:@"Dryers: %@", dryerCount];
      cell.userInteractionEnabled = YES;
      
      cell.washer1.textColor   = [YMTheme gray];
      cell.washer1.highlightedTextColor = cell.washer1.textColor;
      cell.dryer1.textColor    = [YMTheme gray];
      cell.dryer1.highlightedTextColor = cell.dryer1.textColor;
      
      if ([washerCount isEqualToString:@"0"]) {
        cell.washer1.textColor = [YMTheme YMBluebookOrange];
        cell.washer1.highlightedTextColor = [YMTheme YMOrange];
      }
      
      if ([dryerCount isEqualToString:@"0"]) {
        cell.dryer1.textColor = [YMTheme YMBluebookOrange];
        cell.dryer1.highlightedTextColor = [YMTheme YMOrange];
      }
    } else {
      cell.washer1.text = @"Pls refresh";
      cell.dryer1.text = @"Pull to refresh";
      cell.userInteractionEnabled = NO;
    }
    
    if (indexPath.row == FIRST_CELL_INDEX) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
    } else if (indexPath.row == LAST_CELL_INDEX) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else if (indexPath.row==RECENT_CELL_INDEX) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_topbottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    cell.backgroundView.alpha = 0.6;
    cell.location1.textColor = [YMTheme gray];
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == SELECT_LOCATION_INDEX || indexPath.row == RECENT_TITLE_INDEX) return 38;
  else if (indexPath.row == FIRST_CELL_INDEX) return 67;
  else if (indexPath.row == LAST_CELL_INDEX) return 65;
  else return 57;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row==RECENT_CELL_INDEX) {
    [self displayRecent:nil];
  } else {
    self.selectedIndexPath = indexPath;
    [[NSUserDefaults standardUserDefaults] setObject:[self.url objectAtIndex:indexPath.row - NUM_EXTRA_ROWS] forKey:RECENT_LAUNDRY_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Laundry URL stored:%@", [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_LAUNDRY_URL]);
    [self performSegueWithIdentifier:@"Laundry Segue" sender:self];
  }
}

@end
